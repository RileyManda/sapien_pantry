class Category {
  String id;
  String category;

  Category({
    required this.id,
    required this.category,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
  };
}
