import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moatmat_app/User/Core/injection/app_inj.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/shadows_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Features/notifications/domain/usecases/read_notifications_uc.dart';
import 'package:moatmat_app/User/Presentation/home/state/cubit/notifications_cubit.dart';

import '../../../Core/resources/texts_resources.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    context.read<NotificationsCubit>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.notifications),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInitial) {
            locator<ReadNotificationsUC>().call(state.notifications);
            return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  var format = DateFormat("yyyy / MM / dd");
                  var dateString =
                      format.format(state.notifications[index].date);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: SizesResources.s1,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: SizesResources.s3,
                          horizontal: SizesResources.s3,
                        ),
                        width: SpacingResources.mainWidth(context),
                        decoration: BoxDecoration(
                          color: ColorsResources.onPrimary,
                          boxShadow: ShadowsResources.mainBoxShadow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                state.notifications[index].title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: ColorsResources.blackText1,
                                ),
                              ),
                            ),
                            const SizedBox(height: SizesResources.s3),
                            SizedBox(
                              child: Text(
                                state.notifications[index].content,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorsResources.blackText2,
                                ),
                              ),
                            ),
                            const SizedBox(height: SizesResources.s3),
                            SizedBox(
                              child: Text(
                                dateString,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorsResources.blackText2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
