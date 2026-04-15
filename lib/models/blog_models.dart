// lib/models/blog_models.dart

/// A single section in the article body (heading + paragraphs).
class BlogSection {
  final String? heading;
  final List<String> paragraphs;

  const BlogSection({this.heading, required this.paragraphs});
}

class BlogArticle {
  final String id;
  final String imageAsset;
  final String category;
  final String title;
  final String description;
  final String author;
  final String date;
  final String readTime;
  final List<BlogSection> body;
  final List<String> tags;

  const BlogArticle({
    required this.id,
    required this.imageAsset,
    required this.category,
    required this.title,
    required this.description,
    required this.author,
    required this.date,
    this.readTime = '5 min read',
    this.body = const [],
    this.tags = const [],
  });
}
