import 'package:dailyfeed/domain/entities/article.dart';

/// Result wrapper for a page of news.
class NewsPage {
  const NewsPage({
    required this.articles,
    this.nextPage,
    this.fromCache = false,
  });

  final List<Article> articles;
  final String? nextPage;
  final bool fromCache;

  bool get hasMore => nextPage != null && nextPage!.isNotEmpty;
}

abstract class NewsRepository {
  Future<NewsPage> getNews({
    String query = '',
    String? page,
    bool forceRefresh = false,
  });
}
