class FoodModel {
  final String id;
  final String name;
  final String restaurantName;
  final double price;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final String soldCount;
  final String categoryId;

  const FoodModel({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.price,
    required this.imageUrl,
    this.rating = 4.9,
    this.deliveryTime = '15–20 ph',
    this.soldCount = '1k+ đã mua',
    this.categoryId = '',
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      rating: (json['rating'] ?? 4.9).toDouble(),
      deliveryTime: json['deliveryTime'] ?? '15–20 ph',
      soldCount: json['soldCount'] ?? '1k+ đã mua',
      categoryId: json['categoryId'] ?? json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restaurantName': restaurantName,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'soldCount': soldCount,
      'categoryId': categoryId,
    };
  }
}
