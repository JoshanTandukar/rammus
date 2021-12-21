import 'package:rammus/rammus.dart';

class NotificationChannel
{
  const NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
  });
  final String id;
  final String name;
  final String description;
  final AndroidNotificationImportance importance;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "importance": importance.index + 1
    };
  }
}