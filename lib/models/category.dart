import 'package:flutter_cookbook/common/widgets/category_icon.dart';

class Category{
  final String id;
  final String name;
  bool isChecked;
  final CategoryIcon icon;

  Category({
    required this.id,
    required this.name,
    this.isChecked = true,
    required this.icon,
    });

    toggleCheckbox() {
      isChecked = !isChecked;
    }
}
