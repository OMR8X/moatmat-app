import 'package:equatable/equatable.dart';

class NotificationsTopic extends Equatable {
  final String id;
  final String name;
  final bool isSubscribable;

  const NotificationsTopic({
    required this.id,
    required this.name,
    required this.isSubscribable,
  });

  factory NotificationsTopic.empty() => NotificationsTopic(
        id: "-1",
        name: "",
        isSubscribable: true,
      );

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
