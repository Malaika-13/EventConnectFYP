class Venue {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category; // Resort, Corporate Hall, Banquet, Marquee

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
  });
}
