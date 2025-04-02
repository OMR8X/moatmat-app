import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/spacing_resources.dart';

class ExploreQuestionAppBarWidget extends StatelessWidget {
  const ExploreQuestionAppBarWidget({
    super.key,
    required this.onPop,
    this.time,
    required this.title,
  });
  final VoidCallback onPop;
  final Duration? time;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: SpacingResources.sidePadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsResources.darkPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onPop,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.close,
                            color: ColorsResources.whiteText1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (time != null)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: ColorsResources.darkPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: Text(
                            getTime(),
                            style: FontsResources.extraBoldStyle().copyWith(
                              color: ColorsResources.whiteText1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (title.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: ColorsResources.darkPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        title,
                        style: FontsResources.extraBoldStyle().copyWith(
                          color: ColorsResources.whiteText1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTime() {
    String m = (time!.inMinutes % 60).toString();
    String s = (time!.inSeconds % 60).toString();
    return "${m.padLeft(2, "0")}:${s.padLeft(2, "0")}";
  }
}
