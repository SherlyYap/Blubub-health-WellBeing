class Food {
  final String title;
  final String category;
  final String image;
  final String description;
  final double rating;

  Food({
    required this.title,
    required this.category,
    required this.image,
    required this.description,
    required this.rating,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      title: json['title'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }
}
