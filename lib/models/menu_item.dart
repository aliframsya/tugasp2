class MenuItem {
  final String id;
  final String name;
  final String category; // 'Makanan Berat', 'Camilan', 'Minuman', 'Paket Hemat'
  final int price;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;
  final int prepTimeMinutes;
  final bool isAvailable;
  final bool isPopular;
  final List<String> availableToppings;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
    required this.prepTimeMinutes,
    this.isAvailable = true,
    this.isPopular = false,
    this.availableToppings = const [],
  });
}
