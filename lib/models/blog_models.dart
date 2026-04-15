// lib/models/blog_models.dart

class BlogArticle {
  final String id;
  final String imageAsset;
  final String category;
  final String title;
  final String description;
  final String author;
  final String date;

  const BlogArticle({
    required this.id,
    required this.imageAsset,
    required this.category,
    required this.title,
    required this.description,
    required this.author,
    required this.date,
  });
}
