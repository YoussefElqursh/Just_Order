class NotificationModel {
  final String title;
  final String description;
  final String time;
  final String icon;
  final String id;
  final String type;
  final String status;
  final String? route;

  NotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.id,
    required this.type,
    required this.status,
    this.route,
  });
}