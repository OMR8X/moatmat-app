import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/functions/parsers/time_ago.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/validators/not_empty_v.dart';
import 'package:moatmat_app/User/Features/video/domain/entites/comment.dart';
import 'package:moatmat_app/User/Presentation/auth/view/error_v.dart';
import 'package:moatmat_app/User/Presentation/videos/state/VideoBloc/video_bloc.dart';

class AddReplyBottomSheetWidget extends StatefulWidget {
  const AddReplyBottomSheetWidget({
    super.key,
    required this.comment,
  });
  final Comment comment;

  @override
  State<AddReplyBottomSheetWidget> createState() => _AddReplyBottomSheetWidgetState();
}

class _AddReplyBottomSheetWidgetState extends State<AddReplyBottomSheetWidget> {
  final TextEditingController replyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizesResources.s4),
            topRight: Radius.circular(SizesResources.s4),
          ),
          color: ColorsResources.onPrimary,
        ),
        padding: EdgeInsets.only(top: SizesResources.s2),
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
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.comment.username,
                          style: FontsResources.styleBold(),
                        ),
                        Text(
                          timeAgo(widget.comment.createdAt),
                          style: FontsResources.lightStyle(),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      widget.comment.comment,
                      style: FontsResources.styleMedium(),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state.isLoading[Loading.replies] == true) {
                          return Center(
                            child: CupertinoActivityIndicator(
                              color: ColorsResources.primary,
                            ),
                          );
                        } else if (state.errorMsg != null) {
                          return ErrorView(error: state.errorMsg);
                        } else if (state.repliesMap.containsKey(widget.comment.id)) {
                          return ListView.builder(
                            itemCount: state.repliesMap[widget.comment.id]!.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.repliesMap[widget.comment.id]![index].username,
                                          style: FontsResources.styleBold(),
                                        ),
                                        Text(
                                          timeAgo(state.repliesMap[widget.comment.id]![index].createdAt),
                                          style: FontsResources.lightStyle(),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      state.repliesMap[widget.comment.id]![index].comment,
                                      style: FontsResources.styleMedium(),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizesResources.s2) + EdgeInsets.only(bottom: SizesResources.s2),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: SizesResources.s2,
                          bottom: SizesResources.s1,
                        ),
                        child: TextFormField(
                          controller: replyController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (value) {
                            return (notEmptyValidator(text: value) ?? "").isNotEmpty ? "" : null;
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
                            errorStyle: TextStyle(height: 0, fontSize: 0),
                            hint: Text(''),
                            isDense: true,
                            filled: true,
                            fillColor: ColorsResources.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<VideoBloc, VideoState>(
                      builder: (context, state) {
                        if (state.addReplies == true) {
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: CupertinoActivityIndicator(
                              color: ColorsResources.primary,
                            ),
                          );
                        }
                        return IconButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<VideoBloc>().add(
                                    AddReply(
                                      replyText: replyController.text,
                                      commentId: widget.comment.id,
                                    ),
                                  );
                              replyController.text = "";
                            }
                          },
                          icon: Icon(Icons.send),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
