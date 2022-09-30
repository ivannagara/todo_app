class TodoList {
  String? id;
  final String title;
  final Map icon; 
  // Type is Map since you want to store 
  // the icon ID and icon color
  // Map is nothing but a collection of key value pairs
  final int reminderCount;

  // normal constructor, it construct the properties 
  // with the basic construction technique
  TodoList({
    required this.id,
    required this.title, 
    required this.icon,
    required this.reminderCount,
    });

  Map<String, dynamic> toJson() => 
    {
      'id': id,
      'title': title,
      'icon':icon,
      'reminder_count': reminderCount,
    };

  // This is called named constructor, it constructs 
  // the properties from other datas.
  // We pass in the json data, and the json data must have 
  // the properties that are listed below.
  TodoList.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    title = json['title'],
    icon = json['icon'],
    reminderCount = json['reminder_count'];
}