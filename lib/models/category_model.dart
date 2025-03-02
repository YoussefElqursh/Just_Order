class Categories {
  String categoryId;
  String categoryName;
  String categoryImage;

  Categories({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  static Categories fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
    };
  }
}
