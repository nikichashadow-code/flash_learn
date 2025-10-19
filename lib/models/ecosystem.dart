class Category {
  final int id;
  final String name;
  final String? description;

  Category({required this.id, required this.name, this.description});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );
}

class Topic {
  final int id;
  final int categoryId;
  final String title;
  final String? description;

  Topic({
    required this.id,
    required this.categoryId,
    required this.title,
    this.description,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'],
    categoryId: json['category_id'],
    title: json['title'],
    description: json['description'],
  );
}

class Example {
  final int id;
  final int topicId;
  final String name;
  final String? description;
  final String? link;

  Example({
    required this.id,
    required this.topicId,
    required this.name,
    this.description,
    this.link,
  });

  factory Example.fromJson(Map<String, dynamic> json) => Example(
    id: json['id'],
    topicId: json['topic_id'],
    name: json['name'],
    description: json['description'],
    link: json['link'],
  );
}
