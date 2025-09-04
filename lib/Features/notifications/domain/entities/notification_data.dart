// Not In Use yet
class NotificationData {
  final String sentBy;
  final String type;
  final String? referenceId;

  const NotificationData({
    required this.sentBy,
    required this.type,
    this.referenceId,
  });

  Map<String, dynamic> toJson() => {
        'sent_by': sentBy,
        'type': type,
        if (referenceId != null) 'reference_id': referenceId,
      };

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      sentBy: json['sent_by'] ?? '',
      type: json['type'] ?? 'default',
      referenceId: json['reference_id'],
    );
  }
}