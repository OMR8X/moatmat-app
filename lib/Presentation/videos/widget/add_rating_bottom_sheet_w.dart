import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/fonts_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Presentation/videos/state/VideoBloc/video_bloc.dart';

class AddRatingBottomSheetWidget extends StatefulWidget {
  const AddRatingBottomSheetWidget({super.key});

  @override
  State<AddRatingBottomSheetWidget> createState() => _AddRatingBottomSheetWidgetState();
}

class _AddRatingBottomSheetWidgetState extends State<AddRatingBottomSheetWidget> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 280,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorsResources.onPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizesResources.s4),
            topRight: Radius.circular(SizesResources.s4),
          ),
        ),
        padding: EdgeInsets.all(SizesResources.s2) + EdgeInsets.symmetric(vertical: SizesResources.s2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SizesResources.s10,
              height: SizesResources.s1,
              decoration: BoxDecoration(
                color: ColorsResources.grey,
                borderRadius: BorderRadius.circular(SizesResources.s1),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: SizesResources.s4)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'قيّم هذا الفيديو',
                    style: FontsResources.styleBold(size: 18),
                  ),
                  // النجوم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating ? Icons.star : Icons.star_border,
                          color: ColorsResources.darkPrimary,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: SpacingResources.mainHalfWidth(context),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('إلغاء'),
                        ),
                      ),
                      SizedBox(
                        width: SpacingResources.mainHalfWidth(context),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedRating == 0) return;
                            context.read<VideoBloc>().add(
                                  AddRating(
                                    rating: selectedRating,
                                    videoId: context.read<VideoBloc>().state.video!.id,
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                          child: Text('تأكيد'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
