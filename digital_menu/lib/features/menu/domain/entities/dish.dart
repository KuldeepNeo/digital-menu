class Dish {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final String categoryId;
  final int? createdAt;
  final bool isAvailable;

  const Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.categoryId,
    this.createdAt,
    this.isAvailable = true,
  });
}

