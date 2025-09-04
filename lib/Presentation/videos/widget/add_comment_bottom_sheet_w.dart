import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/Core/resources/colors_r.dart';
import 'package:moatmat_app/Core/resources/fonts_r.dart';
import 'package:moatmat_app/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/Core/validators/not_empty_v.dart';
import 'package:moatmat_app/Presentation/videos/state/VideoBloc/video_bloc.dart';

class AddCommentBottomSheetWidget extends StatefulWidget {
  const AddCommentBottomSheetWidget({super.key});

  @override
  State<AddCommentBottomSheetWidget> createState() => _AddCommentBottomSheetWidgetState();
}

class _AddCommentBottomSheetWidgetState extends State<AddCommentBottomSheetWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorsResources.onPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizesResources.s4),
            topRight: Radius.circular(SizesResources.s4),
          ),
        ),
        padding: EdgeInsets.all(SizesResources.s2) + EdgeInsets.only(top: SizesResources.s2),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إضافة تعليق على الفيديو',
                    style: FontsResources.styleBold(size: 18),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: commentText,
                      maxLines: 3,
                      minLines: 1,
                      validator: (value) {
                        return notEmptyValidator(text: value);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          top: SizesResources.s4,
                          bottom: SizesResources.s3,
                          left: SizesResources.s2,
                          right: SizesResources.s2,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorsResources.borders,
                            width: 0.5,
                          ),
                        ),
                        hint: Text('فيديو مفيد'),
                        filled: true,
                        fillColor: ColorsResources.onPrimary,
                      ),
                    ),
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
                          style: ButtonStyle(),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<VideoBloc>().add(
                                    AddComment(
                                      commentText: commentText.text,
                                      videoId: context.read<VideoBloc>().state.video!.id,
                                    ),
                                  );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('إضافة'),
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
