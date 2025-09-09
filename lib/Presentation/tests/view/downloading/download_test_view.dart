import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/functions/coders/decode.dart';
import 'package:moatmat_app/Core/functions/show_alert.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Presentation/tests/state/download_test/download_test_bloc.dart';
import 'package:moatmat_app/Presentation/tests/state/download_test/download_test_event.dart';
import 'package:moatmat_app/Presentation/tests/state/download_test/download_test_state.dart';
import 'package:moatmat_app/Presentation/tests/state/download_test/downloadable_asset.dart';

class DownloadTestView extends StatefulWidget {
  const DownloadTestView({super.key, required this.testId});
  final int testId;
  @override
  State<DownloadTestView> createState() => _DownloadTestViewState();
}

class _DownloadTestViewState extends State<DownloadTestView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if ([DownloadTestStatus.loading, DownloadTestStatus.success, DownloadTestStatus.failure].contains(context.read<DownloadTestBloc>().state.status)) {
          Navigator.of(context).pop();
          return;
        }
        showAlert(
          context: context,
          title: "تأكيد الإلغاء",
          body: "هل تريد إلغاء تحميل الاختبار؟",
          onAgree: () {
            context.read<DownloadTestBloc>().add(const CancelDownloadTestEvent());
            Navigator.of(context).pop();
          },
        );
      },
      child: BlocProvider(
        create: (context) => context.read<DownloadTestBloc>()..add(InitializeDownloadTestEvent(testId: widget.testId)),
        child: Scaffold(
          backgroundColor: ColorsResources.background,
          body: BlocBuilder<DownloadTestBloc, DownloadTestState>(
            buildWhen: (previous, current) => previous.status != current.status || previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              switch (state.status) {
                case DownloadTestStatus.loading:
                  return const LoadingStateWidget();
                case DownloadTestStatus.failure:
                  return FailureStateWidget(
                    failedAssets: state.assets.where((asset) => asset.state == DownloadState.failed).toList(),
                    errorMessage: state.errorMessage,
                    onRetry: () {
                      context.read<DownloadTestBloc>().add(
                            InitializeDownloadTestEvent(testId: widget.testId),
                          );
                    },
                  );
                case DownloadTestStatus.downloading:
                  return DownloadingStateWidget(state: state);
                case DownloadTestStatus.success:
                  return const SuccessStateWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل الاختبار'),
        backgroundColor: ColorsResources.background,
      ),
      body: Center(
        child: CupertinoActivityIndicator(
          color: ColorsResources.primary,
        ),
      ),
    );
  }
}

class FailureStateWidget extends StatelessWidget {
  const FailureStateWidget({
    super.key,
    required this.failedAssets,
    required this.errorMessage,
    required this.onRetry,
  });
  final List<DownloadableAsset> failedAssets;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل الاختبار'),
        backgroundColor: ColorsResources.background,
      ),
      body: Center(
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "فشل تحميل بعض الملفات",
                // errorMessage ?? 'خطأ غير معروف',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تفاصيل الخطأ'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: failedAssets
                              .map(
                                (asset) => Text('اسم الملف : ${decodeFileName(asset.url.split("/").last.split(".").first)}\nالخطأ : ${asset.errorMessage}'),
                              )
                              .toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('حسنا'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('تفاصيل'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadingStateWidget extends StatelessWidget {
  const DownloadingStateWidget({
    super.key,
    required this.state,
  });

  final DownloadTestState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل الاختبار'),
        backgroundColor: ColorsResources.background,
      ),
      body: Container(
        color: ColorsResources.background,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Assets list
              Expanded(
                child: state.assets.isEmpty
                    ? _buildEmptyState(context)
                    : BlocBuilder<DownloadTestBloc, DownloadTestState>(
                        buildWhen: (previous, current) => previous.assets != current.assets,
                        builder: (context, state) {
                          return ListView.separated(
                            itemCount: 3, // Always 3 groups: videos, images, files
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final AssetType type = AssetType.values[index];
                              final typeAssets = state.assets.where((asset) => asset.type == type).toList();

                              if (typeAssets.isEmpty) {
                                return const SizedBox.shrink(); // Hide empty groups
                              }

                              return _AssetGroupCard(
                                assetType: type,
                                assets: typeAssets,
                              );
                            },
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),
              // Cancel button
              _buildCancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.file_download_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ملفات للتحميل',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          showAlert(
            context: context,
            title: "تأكيد الإلغاء",
            body: "هل تريد إلغاء تحميل الاختبار؟",
            onAgree: () {
              context.read<DownloadTestBloc>().add(const CancelDownloadTestEvent());
            },
          );
        },
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('إلغاء التحميل'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red.shade600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _AssetGroupCard extends StatelessWidget {
  const _AssetGroupCard({
    required this.assetType,
    required this.assets,
  });

  final AssetType assetType;
  final List<DownloadableAsset> assets;

  Widget _buildAssetIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        _getAssetIconData(),
        color: _getTypeColor(),
        size: 20,
      ),
    );
  }

  IconData _getAssetIconData() {
    switch (assetType) {
      case AssetType.video:
        return Icons.play_circle_outlined;
      case AssetType.image:
        return Icons.image_outlined;
      case AssetType.file:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getTypeColor() {
    switch (assetType) {
      case AssetType.video:
        return Colors.blue.shade600;
      case AssetType.image:
        return Colors.green.shade600;
      case AssetType.file:
        return Colors.orange.shade600;
    }
  }

  String _getAssetTypeName() {
    switch (assetType) {
      case AssetType.video:
        return "فيديوهات";
      case AssetType.image:
        return "صور";
      case AssetType.file:
        return "ملفات";
    }
  }

  double _getOverallProgress() {
    if (assets.isEmpty) return 0.0;
    double totalProgress = assets.fold(0.0, (sum, asset) => sum + asset.progress);
    return totalProgress / assets.length;
  }

  String _getStatusText() {
    final completedCount = assets.where((asset) => asset.state == DownloadState.completed).length;
    final downloadingCount = assets.where((asset) => asset.state == DownloadState.downloading).length;

    if (completedCount == assets.length) {
      return "مكتمل";
    } else if (downloadingCount > 0) {
      return "جاري التحميل...";
    } else {
      return "في الانتظار";
    }
  }

  Color _getProgressColor() {
    final completedCount = assets.where((asset) => asset.state == DownloadState.completed).length;
    final downloadingCount = assets.where((asset) => asset.state == DownloadState.downloading).length;

    if (completedCount == assets.length) {
      return Colors.green;
    } else if (downloadingCount > 0) {
      return ColorsResources.darkPrimary;
    } else {
      return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final overallProgress = _getOverallProgress();
    final isDownloading = assets.any((asset) => asset.state == DownloadState.downloading);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildAssetIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getAssetTypeName(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${assets.length} ${assets.length == 1 ? "عنصر" : "عناصر"}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${overallProgress.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getProgressColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getStatusText(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ],
          ),
          if (isDownloading) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: overallProgress / 100.0,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SuccessStateWidget extends StatelessWidget {
  const SuccessStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل الاختبار'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'redownload') {
                context.read<DownloadTestBloc>().add(InitializeDownloadTestEvent(testId: context.read<DownloadTestBloc>().state.test!.id, forceDownload: true));
              } else if (value == 'delete') {
                showAlert(
                  context: context,
                  title: "تأكيد الحذف",
                  body: "هل أنت متأكد أنك تريد حذف هذا الاختبار من ذاكرة التخزين المؤقت؟",
                  onAgree: () {
                    context.read<DownloadTestBloc>().add(DeleteCachedTestEvent(testId: context.read<DownloadTestBloc>().state.test!.id));
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'redownload',
                child: Text('إعادة تحميل الاختبار'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('حذف الاختبار من الجهاز'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated success icon
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Success message with fade animation
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'تم التحميل بنجاح!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يمكنك الآن الوصول إلى جميع محتويات الاختبار في وضع الغير متصل بالانترنت',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: SizesResources.s10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('إغلاق'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
