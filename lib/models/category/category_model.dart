class CategoryModel {
  CategoryModel({
    required this.image,
    required this.id,
    required this.name,
  });

  String image;
  String name;

  String id;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
      };
}
