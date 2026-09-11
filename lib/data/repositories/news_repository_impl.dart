import 'dart:convert';

import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/core/exceptions.dart';
import 'package:dailyfeed/data/models/article_model.dart';
import 'package:dailyfeed/data/services/api_service.dart';
import 'package:dailyfeed/data/services/storage_service.dart';
import 'package:dailyfeed/domain/entities/article.dart';
import 'package:dailyfeed/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._api);

  final ApiService _api;

  static const String _cacheKeyPrefix = 'feed_';

  @override
  Future<NewsPage> getNews({
    String query = '',
    String? page,
    bool forceRefresh = false,
  }) async {
    final isFirstPage = page == null || page.isEmpty;

    try {
      final json = await _api.get(
        '${AppConfig.newsBaseUrl}/api/1/latest',
        query: <String, dynamic>{
          'apikey': AppConfig.newsApiKey,
          'language': 'en',
          'size': AppConfig.pageSize,
          if (query.trim().isNotEmpty) 'q': query.trim(),
          if (!isFirstPage) 'page': page,
        },
      );

      if (json['status'] == 'error') {
        throw AppException.server(
          (json['results'] is List && (json['results'] as List).isNotEmpty)
              ? (json['results'] as List).first.toString()
              : 'News service returned an error.',
        );
      }

      final results = (json['results'] as List?) ?? const [];
      final articles = results
          .whereType<Map>()
          .map(
            (e) =>
                ArticleModel.fromJson(Map<String, dynamic>.from(e)).toEntity(),
          )
          .toList();

      // Cache the first page for offline use.
      if (isFirstPage && articles.isNotEmpty) {
        await _cacheArticles(query, articles);
      }

      return NewsPage(
        articles: articles,
        nextPage: json['nextPage'] as String?,
      );
    } on AppException catch (e) {
      // Offline fallback: serve the cached first page.
      if (isFirstPage && !forceRefresh && _isOfflineError(e)) {
        final cached = _readCached(query);
        if (cached.isNotEmpty) {
          return NewsPage(articles: cached, fromCache: true);
        }
      }
      rethrow;
    }
  }

  bool _isOfflineError(AppException e) =>
      e.type == AppErrorType.noInternet || e.type == AppErrorType.timeout;

  String _cacheKey(String query) =>
      '$_cacheKeyPrefix${query.trim().toLowerCase()}';

  Future<void> _cacheArticles(String query, List<Article> articles) async {
    final encoded = jsonEncode(
      articles.map((a) => ArticleModel.fromEntity(a).toJson()).toList(),
    );
    await StorageService.settings.put(_cacheKey(query), encoded);
  }

  List<Article> _readCached(String query) {
    final raw = StorageService.settings.get(_cacheKey(query));
    if (raw is! String || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .whereType<Map>()
          .map(
            (e) =>
                ArticleModel.fromJson(Map<String, dynamic>.from(e)).toEntity(),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
