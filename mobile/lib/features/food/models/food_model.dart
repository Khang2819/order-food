class FoodOption {
  final String id;
  final String name;
  final String description;
  final double price;

  const FoodOption({
    required this.id,
    required this.name,
    this.description = '',
    this.price = 0,
  });

  factory FoodOption.fromJson(Map<String, dynamic> json) {
    return FoodOption(
      id: json['id'] ?? json['_id'] ?? json['name'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}

class FoodModel {
  final String id;
  final String name;
  final String restaurantName;
  final double price;
  final String imageUrl;
  final String description;
  final String tag;
  final double rating;
  final String ratingCount;
  final String deliveryTime;
  final String calories;
  final String secretTip;
  final String soldCount;
  final String categoryId;
  final List<FoodOption> sizes;
  final List<FoodOption> toppings;

  const FoodModel({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.tag = 'Món Bán Chạy Nhất Sài Gòn',
    this.rating = 4.9,
    this.ratingCount = '1.2k',
    this.deliveryTime = '15–20 phút',
    this.calories = '680 kcal',
    this.secretTip = 'Sườn ướp nước mắm nhĩ Phú Quốc nướng than hoa thơm lừng.',
    this.soldCount = '1.2k+ đã mua',
    this.categoryId = '',
    this.sizes = const [],
    this.toppings = const [],
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      description: json['description'] ?? '',
      tag: json['tag'] ?? 'Món Bán Chạy Nhất Sài Gòn',
      rating: (json['rating'] ?? 4.9).toDouble(),
      ratingCount: json['ratingCount'] ?? '1.2k',
      deliveryTime: json['deliveryTime'] ?? '15–20 phút',
      calories: json['calories'] ?? '680 kcal',
      secretTip: json['secretTip'] ?? 'Sườn ướp nước mắm nhĩ Phú Quốc nướng than hoa thơm lừng.',
      soldCount: json['soldCount'] ?? '1.2k+ đã mua',
      categoryId: json['categoryId'] ?? json['category'] ?? '',
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((item) => FoodOption.fromJson(item))
              .toList() ??
          [],
      toppings: (json['toppings'] as List<dynamic>?)
              ?.map((item) => FoodOption.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restaurantName': restaurantName,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'tag': tag,
      'rating': rating,
      'ratingCount': ratingCount,
      'deliveryTime': deliveryTime,
      'calories': calories,
      'secretTip': secretTip,
      'soldCount': soldCount,
      'categoryId': categoryId,
      'sizes': sizes.map((s) => s.toJson()).toList(),
      'toppings': toppings.map((t) => t.toJson()).toList(),
    };
  }
}
