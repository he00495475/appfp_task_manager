import 'dart:convert';

class Category {
  String id;
  String title;
  Category({
    this.id = '',
    this.title = '',
  });

  Category copyWith({
    String? id,
    String? title,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
