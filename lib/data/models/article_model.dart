import 'package:dailyfeed/domain/entities/article.dart';

/// Data-layer representation of an article. Knows how to convert to/from JSON.
class ArticleModel {
  const ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.link,
    required this.keywords,
    required this.creator,
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

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['pubDate'] as String?;
    final parsedDate = rawDate != null
        ? DateTime.tryParse(rawDate.replaceFirst(' ', 'T')) ?? DateTime.now()
        : DateTime.now();

    final link = json['link'] as String? ?? '';
    final id = (json['article_id'] as String?)?.trim();
    final title = (json['title'] as String?)?.trim();

    return ArticleModel(
      id: (id != null && id.isNotEmpty)
          ? id
          : (link.isNotEmpty
                ? link
                : DateTime.now().microsecondsSinceEpoch.toString()),
      title: (title != null && title.isNotEmpty) ? title : 'Untitled',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      sourceName: (json['source_name'] as String?) ?? 'Unknown source',
      publishedAt: parsedDate,
      link: link,
      keywords: _toList(json['keywords']),
      creator: _toList(json['creator']).join(', '),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'article_id': id,
    'title': title,
    'description': description,
    'content': content,
    'image_url': imageUrl,
    'source_name': sourceName,
    'pubDate': publishedAt.toIso8601String(),
    'link': link,
    'keywords': keywords,
    'creator': creator,
  };

  Article toEntity() => Article(
    id: id,
    title: title,
    description: description,
    content: content,
    imageUrl: imageUrl,
    sourceName: sourceName,
    publishedAt: publishedAt,
    link: link,
    keywords: keywords,
    creator: creator,
  );

  factory ArticleModel.fromEntity(Article article) => ArticleModel(
    id: article.id,
    title: article.title,
    description: article.description,
    content: article.content,
    imageUrl: article.imageUrl,
    sourceName: article.sourceName,
    publishedAt: article.publishedAt,
    link: article.link,
    keywords: article.keywords,
    creator: article.creator,
  );

  static List<String> _toList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const <String>[];
  }
}
