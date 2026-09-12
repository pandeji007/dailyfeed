/// Pure business object — no JSON, no Flutter.
class Article {
  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    this.link = '',
    this.keywords = const <String>[],
    this.creator = '',
    this.sourceUrl = '',
  });

  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String sourceName;
  final DateTime publishedAt;
  final String link;
  final List<String> keywords;
  final String creator;
  final String sourceUrl;
}
