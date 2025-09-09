import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/errors/export_errors.dart';
import 'package:moatmat_app/Core/errors/failures.dart';
import 'package:moatmat_app/Features/buckets/domain/requests/cache_asset_request.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/cache_asset_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/cache_test_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/delete_cached_test_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_cached_tests_uc.dart';
import 'package:moatmat_app/Features/tests/domain/usecases/get_test_by_id.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'download_test_event.dart';
import 'download_test_state.dart';
import 'downloadable_asset.dart';

class DownloadTestBloc extends Bloc<DownloadTestEvent, DownloadTestState> {
  final GetTestByIdUC _getTestByIdUsecase;
  final CacheAssetUC _cacheAssetUsecase;
  final CacheTestUC _cacheTestUsecase;
  final GetCachedTestsUC _getCachedTestsUsecase;
  final DeleteCachedTestUC _deleteCachedTestUC;

  DownloadTestBloc(this._getTestByIdUsecase, this._cacheAssetUsecase, this._cacheTestUsecase, this._getCachedTestsUsecase, this._deleteCachedTestUC) : super(const DownloadTestState()) {
    on<InitializeDownloadTestEvent>(_onInitializeDownloadTestEvent);
    on<CancelDownloadTestEvent>(_onCancelDownloadTestEvent);
    on<DeleteCachedTestEvent>(_onDeleteCachedTestEvent);
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

  Future<void> _onInitializeDownloadTestEvent(
    InitializeDownloadTestEvent event,
    Emitter<DownloadTestState> emit,
  ) async {
    try {
      ///
      emit(state.copyWith(status: DownloadTestStatus.loading, assets: [], errorMessage: null, test: null));

      ///
      await _checkIfTestIsCached(event, emit);
    } catch (error) {
      if (emit.isDone) return;
      emit(state.copyWith(
        status: DownloadTestStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _checkIfTestIsCached(
    InitializeDownloadTestEvent event,
    Emitter<DownloadTestState> emit,
  ) async {
    final cachedTestsResult = await _getCachedTestsUsecase();

    await cachedTestsResult.fold(
      (failure) async => await _downloadTestFlow(event.testId, emit),
      (cachedTests) async {
        //
        final cachedTest = cachedTests.firstWhereOrNull((test) => test.id == event.testId);
        //
        if (cachedTest != null && event.forceDownload != true) {
          if (!emit.isDone) {
            emit(state.copyWith(
              status: DownloadTestStatus.success,
              test: cachedTest,
              assets: [],
            ));
          }
        } else {
          await _downloadTestFlow(event.testId, emit);
        }
      },
    );
  }

  Future<void> _downloadTestFlow(int testId, Emitter<DownloadTestState> emit) async {
    final result = await _getTestByIdUsecase(id: testId);
    await result.fold(
      (failure) async {
        if (emit.isDone) return;
        emit(state.copyWith(
          status: DownloadTestStatus.failure,
          errorMessage: failure.toString(),
        ));
      },
      (test) async {
        ///
        final newAssets = _extractAllAssets(test);
        // Preserve existing asset states if this is a retry
        final assetsWithPreservedStates = _preserveAssetStates(newAssets, state.assets);
        //
        emit(state.copyWith(
          status: DownloadTestStatus.downloading,
          test: test,
          assets: assetsWithPreservedStates,
        ));

        /// Start downloading
        if (assetsWithPreservedStates.isEmpty) {
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
              if (emit.isDone) return;
              emit(state.copyWith(
                status: DownloadTestStatus.success,
              ));
            },
          );
          return;
        }

        // Download each asset with progress
        final updatedAssets = List<DownloadableAsset>.from(assetsWithPreservedStates);

        for (int i = 0; i < assetsWithPreservedStates.length; i++) {
          ///
          if (emit.isDone) return;

          ///
          final asset = assetsWithPreservedStates[i];

          // skip assets that are already completed
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
                final assets = List<DownloadableAsset>.from(state.assets);
                assets[i] = asset.copyWith(
                  state: DownloadState.downloading,
                  progress: (received / total) * 100,
                );
                emit(state.copyWith(assets: assets));
              }
            },
          );

          final result = await _cacheAssetUsecase(
            request: request,
          );

          if (!isClosed && !emit.isDone) {
            await result.fold(
              (failure) async {
                debugPrint("failure: $failure");
                if (failure is CancelFailure) return;
                updatedAssets[i] = asset.copyWith(state: DownloadState.failed, errorMessage: failure.message);
                if (!emit.isDone) {
                  emit(state.copyWith(assets: updatedAssets));
                }
              },
              (cachedAsset) async {
                updatedAssets[i] = asset.copyWith(state: DownloadState.completed, progress: 100.0, errorMessage: null);
                if (!emit.isDone) {
                  emit(state.copyWith(assets: updatedAssets));
                }
              },
            );
          }
        }

        // Cache test and emit success
        if (!isClosed && !emit.isDone) {
          final failedAssets = updatedAssets.where((asset) => asset.state == DownloadState.failed).length;

          if (failedAssets <= 0) {
            // Cache the test after processing all assets
            final cacheResult = await _cacheTestUsecase(test: test);

            await cacheResult.fold(
              (failure) async {
                if (emit.isDone) return;
                emit(state.copyWith(
                  status: DownloadTestStatus.failure,
                  errorMessage: 'فشل حفظ الاختبار: ${failure.message}',
                ));
              },
              (_) async {
                if (emit.isDone) return;
                emit(state.copyWith(status: DownloadTestStatus.success));
              },
            );
          } else {
            if (emit.isDone) return;
            final networkFailures = failedAssets;
            if (networkFailures > 0) {
              emit(state.copyWith(
                status: DownloadTestStatus.failure,
                errorMessage: 'فشل تحميل الملفات. يرجى المحاولة مرة أخرى.',
              ));
            } else {
              emit(state.copyWith(status: DownloadTestStatus.success));
            }
          }
        }
      },
    );
  }

  /// Preserve asset states from previous download attempts
  List<DownloadableAsset> _preserveAssetStates(List<DownloadableAsset> newAssets, List<DownloadableAsset> existingAssets) {
    return newAssets.map((newAsset) {
      final matchingAssets = existingAssets.where((existing) => existing.url == newAsset.url);
      final existingAsset = matchingAssets.isNotEmpty ? matchingAssets.first : null;

      if (existingAsset != null) {
        return newAsset.copyWith(
          state: existingAsset.state,
          progress: existingAsset.progress,
          errorMessage: existingAsset.errorMessage,
        );
      }

      return newAsset;
    }).toList();
  }

  void _onCancelDownloadTestEvent(
    CancelDownloadTestEvent event,
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

  Future<void> _onDeleteCachedTestEvent(
    DeleteCachedTestEvent event,
    Emitter<DownloadTestState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DownloadTestStatus.loading, errorMessage: null));
      final result = await _deleteCachedTestUC(testId: event.testId);

      await result.fold(
        (failure) async {
          emit(state.copyWith(
            status: DownloadTestStatus.failure,
            errorMessage: failure.message,
          ));
        },
        (_) async {
          // Optionally, navigate back or update the list of cached tests
          // For now, we'll just emit a success state and clear the test info
          emit(state.copyWith(
            status: DownloadTestStatus.loading,
            test: null,
            assets: [],
          ));
        },
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        status: DownloadTestStatus.failure,
        errorMessage: 'فشل حذف الاختبار: ${e.toFailure.message}',
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
