import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:moatmat_app/Core/functions/coders/decode.dart';
import 'package:moatmat_app/Core/injection/app_inj.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/Features/buckets/domain/requests/retrieve_asset_request.dart';
import 'package:moatmat_app/Features/buckets/domain/usecases/retrieve_asset_uc.dart';
import 'package:moatmat_app/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/Presentation/tests/state/download_test/downloadable_asset.dart';
import 'package:moatmat_app/Presentation/videos/view/offline_video_v.dart';
import 'package:moatmat_app/Presentation/videos/view/video_v.dart';
import 'package:moatmat_app/Presentation/videos/widgets/file_card_widget.dart';
import 'package:moatmat_app/Presentation/videos/widgets/video_card_widget.dart';
import '../../tests/view/exploring/explore_no_time_v.dart';
import '../../tests/view/exploring/full_time_explore_v.dart';
import '../../tests/view/exploring/per_question_explore_v.dart';
import '../../tests/widgets/test_q_box.dart';

class TestAssetsView extends StatefulWidget {
  const TestAssetsView({
    super.key,
    required this.test,
    this.isOffline = false,
  });
  final bool isOffline;
  final Test test;

  @override
  State<TestAssetsView> createState() => _TestAssetsViewState();
}

class _TestAssetsViewState extends State<TestAssetsView> {
  bool isLoading = false;
  // (index,type)
  List<(int, AssetType)> loadingAssets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(
            "موارد مرفقة يجب مطالعتها قبل الاختبار",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        actions: [
          if (widget.isOffline)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("مشكلة في الملفات؟"),
                    content: const Text(
                      "إذا واجهت أي مشكلة في فتح أو استعراض المستندات، يمكنك حذف الاختبار وإعادة تنزيله من شاشة تنزيل الاختبارات.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("حسناً"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
        ],
      ),
      body: ListView(
        children: [
          //
          const SizedBox(
            width: double.infinity,
            height: SizesResources.s4,
          ),
          //
          if (widget.test.information.images?.isNotEmpty ?? false) ...[
            const MiniTestTitleWidget(title: "صور"),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: SpacingResources.sidePadding),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.test.information.images!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.test.information.images!.length == 1 ? 1 : 2,
                mainAxisSpacing: SizesResources.s2,
                crossAxisSpacing: SizesResources.s2,
                childAspectRatio: 4 / 2,
              ),
              itemBuilder: (context, index) {
                final image = widget.test.information.images![index];
                return InkWell(
                  onTap: () async {
                    if (widget.isOffline) {
                      final result = await locator<RetrieveAssetUC>().call(request: RetrieveAssetRequest.fromSupabaseLink(image));
                      result.fold(
                        (l) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.toString()),
                            ),
                          );
                        },
                        (r) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ExploreImage(
                                image: Image.file(r),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExploreImage(
                            image: Image.network(image),
                          ),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (widget.isOffline)
                          FutureBuilder(
                            future: locator<RetrieveAssetUC>().call(request: RetrieveAssetRequest.fromSupabaseLink(image)),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(snapshot.error.toString()),
                                  ),
                                );
                              }
                              if (snapshot.connectionState == ConnectionState.done) {
                                return snapshot.data!.fold(
                                  (l) => const SizedBox.shrink(),
                                  (r) => Image.file(r, fit: BoxFit.fill, width: 500),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          )
                        else
                          Image.network(
                            image,
                            fit: BoxFit.fill,
                            width: 500,
                          ),
                        if (widget.test.information.images?.length != 1)
                          Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        if (widget.test.information.images?.length != 1)
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(
            width: double.infinity,
            height: SizesResources.s4,
          ),
          if (widget.test.information.videos?.isNotEmpty ?? false) ...[
            const MiniTestTitleWidget(title: "مقاطع فيديو"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.test.information.videos!.length,
              itemBuilder: (context, index) {
                final video = widget.test.information.videos![index];
                return VideoCardWidget(
                  video: video,
                  isLoading: loadingAssets.contains((index, AssetType.video)),
                  videoNumber: index + 1,
                  onTap: () async {
                    if (isLoading) return;
                    if (widget.isOffline) {
                      setState(() {
                        isLoading = true;
                        loadingAssets.add((index, AssetType.video));
                      });
                      final response = await locator<RetrieveAssetUC>().call(request: RetrieveAssetRequest.fromSupabaseLink(video.url));
                      response.fold(
                        (l) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.toString()),
                          ),
                        ),
                        (path) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OfflineVideoView(videoPath: path.path)));
                        },
                      );
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoView(videoId: video.id)));
                    }
                    setState(() {
                      isLoading = false;
                      loadingAssets.removeWhere((e) => e.$1 == index);
                    });
                  },
                );
              },
            ),
          ],
          const SizedBox(
            width: double.infinity,
            height: SizesResources.s4,
          ),
          if (widget.test.information.files?.isNotEmpty ?? false) ...[
            const MiniTestTitleWidget(title: "مستندات"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.test.information.files!.length,
              itemBuilder: (context, index) {
                final file = widget.test.information.files![index];
                return FileCardWidget(
                  isLoading: loadingAssets.contains((index, AssetType.file)),
                  fileNumber: index + 1,
                  fileUrl: file,
                  onTap: () async {
                    if (isLoading) return;
                    if (widget.isOffline) {
                      setState(() {
                        isLoading = true;
                        loadingAssets.add((index, AssetType.file));
                      });
                      final response = await locator<RetrieveAssetUC>().call(request: RetrieveAssetRequest.fromSupabaseLink(file));
                      response.fold(
                        (l) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.toString()),
                          ),
                        ),
                        (path) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFViewerFromAssetPath(path: path.path)));
                        },
                      );
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFViewerFromUrl(url: file)));
                    }
                    setState(() {
                      isLoading = false;
                      loadingAssets.removeWhere((e) => e.$1 == index);
                    });
                  },
                );
              },
            ),
          ],
          //
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: SizesResources.s10,
          left: SizesResources.s2,
          right: SizesResources.s2,
        ),
        child: ElevatedButtonWidget(
          text: "بدء الاختبار",
          onPressed: () async {
            //
            if (widget.test.information.period == 0 || widget.test.information.period == null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TestExploreNoTimeView(
                    test: widget.test,
                  ),
                ),
              );
            } else {
              if (widget.test.properties.timePerQuestion ?? false) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TestPerQuestionExploreView(
                      minutes: widget.test.information.period!,
                      test: widget.test,
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TestFullTimeExploreView(
                      minutes: widget.test.information.period!,
                      test: widget.test,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class MediaTileWidget extends StatelessWidget {
  const MediaTileWidget({
    super.key,
    required this.file,
    required this.type,
    required this.onPressed,
    required this.color,
  });

  final String file, type;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            // boxShadow: ShadowsResources.mainBoxShadow,
            color: ColorsResources.onPrimary,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s2),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(SizesResources.s2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: SizesResources.s1),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.whiteText1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: SizesResources.s1,
                          right: SizesResources.s1,
                        ),
                        child: Text(
                          decodeFileName(file.split("/").last.split("?").first.replaceAll(".pdf", "")),
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new,
                      size: 20,
                      color: ColorsResources.darkPrimary,
                    ),
                    const SizedBox(width: SizesResources.s1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MiniTestTitleWidget extends StatelessWidget {
  const MiniTestTitleWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: SizesResources.s1),
      child: Row(
        children: [
          //
          Padding(
            padding: const EdgeInsets.only(top: SizesResources.s1),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PDFViewerFromUrl extends StatefulWidget {
  const PDFViewerFromUrl({super.key, required this.url});

  final String url;

  @override
  State<PDFViewerFromUrl> createState() => _PDFViewerFromUrlState();
}

class _PDFViewerFromUrlState extends State<PDFViewerFromUrl> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: const Text(
            'تفاصيل الملف',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
            onPressed: () {
              if (_pdfViewerController.pageNumber > 1) {
                _pdfViewerController.previousPage();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
            onPressed: () {
              if (_pdfViewerController.pageNumber < _pdfViewerController.pageCount) {
                _pdfViewerController.nextPage();
              }
            },
          ),
        ],
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(
          scrollStatusStyle: PdfScrollStatusStyle(
            backgroundColor: Colors.transparent,
            pageInfoTextStyle: const TextStyle(color: Colors.transparent),
          ),
          scrollHeadStyle: PdfScrollHeadStyle(
            backgroundColor: Colors.black,
            pageNumberTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
        child: SfPdfViewer.network(
          widget.url,
          controller: _pdfViewerController,
        ),
      ),
    );
  }
}

class PDFViewerFromAssetPath extends StatefulWidget {
  const PDFViewerFromAssetPath({super.key, required this.path});

  final String path;

  @override
  State<PDFViewerFromAssetPath> createState() => _PDFViewerFromAssetPathState();
}

class _PDFViewerFromAssetPathState extends State<PDFViewerFromAssetPath> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: const Text(
            'تفاصيل الملف',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
            onPressed: () {
              if (_pdfViewerController.pageNumber > 1) {
                _pdfViewerController.previousPage();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70),
            onPressed: () {
              if (_pdfViewerController.pageNumber < _pdfViewerController.pageCount) {
                _pdfViewerController.nextPage();
              }
            },
          ),
        ],
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(
          scrollStatusStyle: PdfScrollStatusStyle(
            backgroundColor: Colors.transparent,
            pageInfoTextStyle: const TextStyle(color: Colors.transparent),
          ),
          scrollHeadStyle: PdfScrollHeadStyle(
            backgroundColor: Colors.black,
            pageNumberTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
        child: SfPdfViewer.file(
          File(widget.path),
          controller: _pdfViewerController,
        ),
      ),
    );
  }
}
