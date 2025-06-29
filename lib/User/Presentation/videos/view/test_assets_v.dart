import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:moatmat_app/User/Core/functions/coders/decode.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'package:moatmat_app/User/Presentation/videos/view/video_play_view.dart';
import '../../tests/view/exploring/explore_no_time_v.dart';
import '../../tests/view/exploring/full_time_explore_v.dart';
import '../../tests/view/exploring/per_question_explore_v.dart';
import '../../tests/widgets/test_q_box.dart';

class TestAssetsView extends StatefulWidget {
  const TestAssetsView({
    super.key,
    required this.test,
  });
  final Test test;

  @override
  State<TestAssetsView> createState() => _TestAssetsViewState();
}

class _TestAssetsViewState extends State<TestAssetsView> {
  late String? video;

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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExploreImage(image: image),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
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
          if (widget.test.information.video?.isNotEmpty ?? false) ...[
            const MiniTestTitleWidget(title: "مقاطع فيديو"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.test.information.video!.length,
              itemBuilder: (context, index) {
                final video = widget.test.information.video![index];
                return MediaTileWidget(
                  file: video.url,
                  type: "MP4",
                  color: ColorsResources.blueText,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerView(link: video.url)));
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
                return MediaTileWidget(
                  file: file,
                  type: "PDF",
                  color: ColorsResources.orangeText,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PDFViewerFromUrl(url: file),
                      ),
                    );
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

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملف'),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$progress %',
                style: const TextStyle(
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: SizesResources.s4),
              const Text('جار تجهيز الملف'),
              const SizedBox(height: SizesResources.s4),
            ],
          ));
        },
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
