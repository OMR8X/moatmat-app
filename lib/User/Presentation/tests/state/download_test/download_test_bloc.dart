import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';
import 'package:moatmat_app/User/Features/buckets/domain/requests/cache_asset_request.dart';
import 'package:moatmat_app/User/Features/buckets/domain/usecases/cache_asset_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/cache_test_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_cached_tests_uc.dart';
import 'package:moatmat_app/User/Features/tests/domain/usecases/get_test_by_id.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'download_test_event.dart';
import 'download_test_state.dart';
import 'downloadable_asset.dart';

class DownloadTestBloc extends Bloc<DownloadTestEvent, DownloadTestState> {
  final GetTestByIdUC _getTestByIdUsecase;
  final CacheAssetUC _cacheAssetUsecase;
  final CacheTestUC _cacheTestUsecase;
  final GetCachedTestsUC _getCachedTestsUsecase;

  DownloadTestBloc(this._getTestByIdUsecase, this._cacheAssetUsecase, this._cacheTestUsecase, this._getCachedTestsUsecase) : super(const DownloadTestState()) {
    on<InitializeDownloadTest>(_onInitializeDownloadTest);
    on<CancelDownloadTest>(_onCancelDownloadTest);
  }

  @override
  Future<void> close() {
    // Cancel all ongoing downloads before closing
    _cancelAllDownloads();
    return super.close();
  }

  void _cancelAllDownloads() {
    for (final asset in state.assets) {
      if (asset.state == DownloadState.downloading || asset.state == DownloadState.pending) {
        asset.cancelToken.cancel('Download cancelled due to bloc disposal');
      }
    }
  }

  Future<void> _onInitializeDownloadTest(
    InitializeDownloadTest event,
    Emitter<DownloadTestState> emit,
  ) async {
    print(event.testId);
    try {
      emit(state.copyWith(
        status: DownloadTestStatus.loading,
        assets: [],
        errorMessage: null,
        test: null,
      ));

      // First, check if the test is already cached
      final cachedTestsResult = await _getCachedTestsUsecase();

      await cachedTestsResult.fold(
        (failure) async {
          // If we can't get cached tests, continue with normal flow
          await _downloadTestFlow(event.testId, emit);
        },
        (cachedTests) async {
          // Check if the test is already cached
          final matchingTests = cachedTests.where((test) => test.id == event.testId);
          final cachedTest = matchingTests.isNotEmpty ? matchingTests.first : null;

          if (cachedTest != null && !kDebugMode) {
            // Test is already cached, emit success immediately
            if (!emit.isDone) {
              emit(state.copyWith(
                status: DownloadTestStatus.success,
                test: cachedTest,
                assets: [], // No assets need to be downloaded
              ));
            }
          } else {
            // Test is not cached, proceed with download
            await _downloadTestFlow(event.testId, emit);
          }
        },
      );
    } catch (error) {
      debugPrint("debug: error: $error");
      if (!emit.isDone) {
        emit(state.copyWith(
          status: DownloadTestStatus.failure,
          errorMessage: error.toString(),
        ));
      }
    }
  }

  Future<void> _downloadTestFlow(int testId, Emitter<DownloadTestState> emit) async {
    final result = await _getTestByIdUsecase(id: testId);

    await result.fold(
      (failure) async {
        if (!emit.isDone) {
          emit(state.copyWith(
            status: DownloadTestStatus.failure,
            errorMessage: failure.toString(),
          ));
        }
      },
      (test) async {
        final newAssets = _extractAllAssets(test);
        // Preserve existing asset states if this is a retry
        final assetsWithPreservedStates = _preserveAssetStates(newAssets, state.assets);
        emit(state.copyWith(
          status: DownloadTestStatus.downloading,
          test: test,
          assets: assetsWithPreservedStates,
        ));

        // Start downloading immediately
        if (assetsWithPreservedStates.isEmpty) {
          // Cache the test even if there are no assets to download
          final cacheResult = await _cacheTestUsecase(test: test);
          await cacheResult.fold(
            (failure) async {
              if (!emit.isDone) {
                emit(state.copyWith(
                  status: DownloadTestStatus.failure,
                  errorMessage: 'فشل حفظ الاختبار: ${failure.toString()}',
                ));
              }
            },
            (_) async {
              if (!emit.isDone) {
                emit(state.copyWith(
                  status: DownloadTestStatus.success,
                ));
              }
            },
          );
          return;
        }

        // Download each asset with progress
        final updatedAssets = List<DownloadableAsset>.from(assetsWithPreservedStates);

        for (int i = 0; i < assetsWithPreservedStates.length; i++) {
          if (emit.isDone) return;

          final asset = assetsWithPreservedStates[i];

          // Skip assets that are already completed from previous attempts
          if (asset.state == DownloadState.completed) {
            continue;
          }

          // Update asset state to downloading
          updatedAssets[i] = asset.copyWith(state: DownloadState.downloading);
          if (!emit.isDone) {
            emit(state.copyWith(assets: updatedAssets));
          }

          CacheAssetRequest request = CacheAssetRequest.fromSupabaseLink(
            link: asset.url,
            cancelToken: asset.cancelToken,
            onProgress: (received, total) {
              if (!isClosed && !emit.isDone) {
                final assetProgress = (received / total) * 100;
                final newAssets = List<DownloadableAsset>.from(state.assets);
                newAssets[i] = asset.copyWith(
                  state: DownloadState.downloading,
                  progress: assetProgress,
                );
                emit(state.copyWith(assets: newAssets));
              }
            },
          );

          final result = await _cacheAssetUsecase(
            request: request,
          );

          if (!isClosed && !emit.isDone) {
            await result.fold(
              (failure) async {
                if (failure is CancelFailure) {
                  return;
                }
                if (failure is AssetNotExistsFailure) {
                  // Mark asset as failed
                  updatedAssets[i] = asset.copyWith(
                    state: DownloadState.failed,
                    progress: 100.0,
                  );
                  if (!emit.isDone) {
                    emit(state.copyWith(assets: updatedAssets));
                  }
                } else {
                  // Stop all downloads and emit failure state
                  _cancelAllDownloads();
                  if (!emit.isDone) {
                    emit(state.copyWith(
                      status: DownloadTestStatus.failure,
                      errorMessage: 'فشل تحميل الملف: ${_getAssetName(asset.url)}',
                    ));
                  }
                }
              },
              (cachedAsset) async {
                // Mark asset as completed
                updatedAssets[i] = asset.copyWith(
                  state: DownloadState.completed,
                  progress: 100.0,
                );
                if (!emit.isDone) {
                  emit(state.copyWith(assets: updatedAssets));
                }
              },
            );
          }
        }

        // Cache test and emit success regardless of individual asset failures
        // Only fail if ALL assets failed or if there's a critical error
        if (!isClosed && !emit.isDone) {
          final successfulAssets = updatedAssets.where((asset) => asset.state == DownloadState.completed && asset.errorMessage == null).length;
          final failedAssets = updatedAssets.where((asset) => asset.state == DownloadState.failed).length;
          final failedButMarkedCompleted = updatedAssets.where((asset) => asset.state == DownloadState.completed && asset.errorMessage != null).length;
          // Continue with caching if at least some assets were successfully downloaded
          // or if there were no assets to download, or if only non-critical failures occurred
          final totalRealFailures = failedAssets + failedButMarkedCompleted;
          final shouldProceed = assetsWithPreservedStates.isEmpty || successfulAssets > 0 || totalRealFailures < assetsWithPreservedStates.length;

          if (shouldProceed) {
            // Cache the test after processing all assets
            final cacheResult = await _cacheTestUsecase(test: test);

            await cacheResult.fold(
              (failure) async {
                if (!emit.isDone) {
                  emit(state.copyWith(
                    status: DownloadTestStatus.failure,
                    errorMessage: 'فشل حفظ الاختبار: ${failure.toString()}',
                  ));
                }
              },
              (_) async {
                if (!emit.isDone) {
                  emit(state.copyWith(
                    status: DownloadTestStatus.success,
                  ));
                }
              },
            );
          } else {
            // Only fail if ALL assets failed with network/critical errors
            if (!emit.isDone) {
              final networkFailures = failedAssets;
              if (networkFailures > 0) {
                emit(state.copyWith(
                  status: DownloadTestStatus.failure,
                  errorMessage: 'فشل تحميل الملفات بسبب مشاكل في الاتصال. يرجى المحاولة مرة أخرى.',
                ));
              } else {
                // All files were unavailable but not due to network issues
                emit(state.copyWith(
                  status: DownloadTestStatus.success,
                ));
              }
            }
          }
        }
      },
    );
  }

  String _getAssetName(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'ملف غير معروف';
  }

  /// Preserve asset states from previous download attempts
  List<DownloadableAsset> _preserveAssetStates(List<DownloadableAsset> newAssets, List<DownloadableAsset> existingAssets) {
    if (existingAssets.isEmpty) return newAssets;

    return newAssets.map((newAsset) {
      // Find matching existing asset by URL
      final matchingAssets = existingAssets.where((existing) => existing.url == newAsset.url);
      final existingAsset = matchingAssets.isNotEmpty ? matchingAssets.first : null;

      if (existingAsset != null) {
        // Preserve the state and progress from the existing asset
        return newAsset.copyWith(
          state: existingAsset.state,
          progress: existingAsset.progress,
          errorMessage: existingAsset.errorMessage,
        );
      }

      return newAsset;
    }).toList();
  }

  void _onCancelDownloadTest(
    CancelDownloadTest event,
    Emitter<DownloadTestState> emit,
  ) {
    try {
      // Cancel all ongoing downloads
      for (final asset in state.assets) {
        if (asset.state == DownloadState.downloading) {
          asset.cancelToken.cancel('Download cancelled by user');
        }
      }

      // Update assets states to reflect cancellation
      final updatedAssets = state.assets.map((asset) {
        if (asset.state == DownloadState.downloading) {
          return asset.copyWith(
            state: DownloadState.failed,
            errorMessage: 'تم إلغاء التحميل',
          );
        }
        return asset;
      }).toList();

      emit(state.copyWith(
        status: DownloadTestStatus.failure,
        errorMessage: 'تم إلغاء التحميل',
        assets: updatedAssets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DownloadTestStatus.failure,
        errorMessage: 'فشل إلغاء التحميل',
      ));
    }
  }

  /// Extract all assets from the test object as DownloadableAsset objects
  List<DownloadableAsset> _extractAllAssets(Test test) {
    final List<DownloadableAsset> assets = [];

    // Extract assets from test information
    final info = test.information;

    // Add images from test information
    if (info.images != null) {
      for (final imageUrl in info.images!.where((url) => url.isNotEmpty)) {
        assets.add(DownloadableAsset(
          url: imageUrl,
          type: AssetType.image,
          cancelToken: CancelToken(),
        ));
      }
    }

    // Add files from test information
    if (info.files != null) {
      for (final fileUrl in info.files!.where((url) => url.isNotEmpty)) {
        assets.add(DownloadableAsset(
          url: fileUrl,
          type: AssetType.file,
          cancelToken: CancelToken(),
        ));
      }
    }

    // Add videos from test information
    if (info.videos != null) {
      for (final video in info.videos!) {
        if (video.url.isNotEmpty) {
          assets.add(DownloadableAsset(
            url: video.url,
            type: AssetType.video,
            cancelToken: CancelToken(),
          ));
        }
      }
    }

    // Extract assets from questions
    for (final question in test.questions) {
      // Add question image
      if (question.image != null && question.image!.isNotEmpty) {
        assets.add(DownloadableAsset(
          url: question.image!,
          type: AssetType.image,
          cancelToken: CancelToken(),
        ));
      }

      // Add question video
      if (question.video != null && question.video!.isNotEmpty) {
        assets.add(DownloadableAsset(
          url: question.video!,
          type: AssetType.video,
          cancelToken: CancelToken(),
        ));
      }

      // Add question explain image
      if (question.explainImage != null && question.explainImage!.isNotEmpty) {
        assets.add(DownloadableAsset(
          url: question.explainImage!,
          type: AssetType.image,
          cancelToken: CancelToken(),
        ));
      }

      // Add answer images
      for (final answer in question.answers) {
        if (answer.image != null && answer.image!.isNotEmpty) {
          assets.add(DownloadableAsset(
            url: answer.image!,
            type: AssetType.image,
            cancelToken: CancelToken(),
          ));
        }
      }
    }

    // Remove duplicates based on URL
    final uniqueAssets = <String, DownloadableAsset>{};
    for (final asset in assets) {
      uniqueAssets[asset.url] = asset;
    }

    // Sort assets by type: videos first, then images, then files
    final sortedAssets = uniqueAssets.values.toList();
    sortedAssets.sort((a, b) {
      const typeOrder = {
        AssetType.video: 0,
        AssetType.image: 1,
        AssetType.file: 2,
      };
      return typeOrder[a.type]!.compareTo(typeOrder[b.type]!);
    });

    return sortedAssets;
  }
}
