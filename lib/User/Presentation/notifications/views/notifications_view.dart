import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_app/User/Core/resources/colors_r.dart';
import 'package:moatmat_app/User/Core/resources/fonts_r.dart';
import 'package:moatmat_app/User/Core/resources/sizes_resources.dart';
import 'package:moatmat_app/User/Core/resources/spacing_resources.dart';
import 'package:moatmat_app/User/Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import 'package:moatmat_app/User/Presentation/notifications/widgets/notification_card_widget.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      BlocProvider.of<NotificationsBloc>(context).add(GetNotifications());
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
      ),
      body: BlocListener<NotificationsBloc, NotificationsState>(
        listenWhen: (previous, current) => previous is! NotificationsLoaded && current is NotificationsLoaded,
        listener: (context, state) {
          if (state is NotificationsLoaded) {
            for (final notification in state.notifications) {
              BlocProvider.of<NotificationsBloc>(context).add(MarkNotificationAsSeen(notification.id));
            }
          }
        },
        child: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is NotificationsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: FontsResources.styleRegular(color: ColorsResources.red),
                ),
              );
            } else if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد إشعارات',
                    style: FontsResources.styleRegular(),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(SpacingResources.sidePadding),
                child: ListView.separated(
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: SizesResources.s1 / 2),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationCard(notification: notification);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
