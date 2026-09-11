import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/data/repositories/news_repository_impl.dart';
import 'package:dailyfeed/domain/entities/article.dart';
import 'package:dailyfeed/domain/repositories/news_repository.dart';
import 'package:dailyfeed/presentation/providers/auth_provider.dart';

// --- Repository --------------------------------------------------------------

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepositoryImpl(ref.watch(apiServiceProvider)),
);

// --- Feed State --------------------------------------------------------------

class NewsState {
  const NewsState({
    this.articles = const <Article>[],
    this.isLoadingMore = false,
    this.hasMore = false,
    this.fromCache = false,
    this.nextPage,
  });

  final List<Article> articles;
  final bool isLoadingMore;
  final bool hasMore;
  final bool fromCache;
  final String? nextPage;

  NewsState copyWith({
    List<Article>? articles,
    bool? isLoadingMore,
    bool? hasMore,
    bool? fromCache,
    String? nextPage,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      fromCache: fromCache ?? this.fromCache,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

/// Family keyed by search query. Use `''` for the home feed.
class NewsNotifier extends FamilyAsyncNotifier<NewsState, String> {
  @override
  Future<NewsState> build(String query) => _loadFirstPage();

  Future<void> refresh() async {
    state = const AsyncLoading(); // <-- lowercase `state`
    state = await AsyncValue.guard(_loadFirstPage);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final page = await ref
          .read(newsRepositoryProvider)
          .getNews(query: arg, page: current.nextPage);
      state = AsyncData(
        current.copyWith(
          articles: [...current.articles, ...page.articles],
          isLoadingMore: false,
          hasMore: page.hasMore,
          nextPage: page.nextPage,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }

  Future<NewsState> _loadFirstPage() async {
    final page = await ref.read(newsRepositoryProvider).getNews(query: arg);
    return NewsState(
      articles: page.articles,
      hasMore: page.hasMore,
      nextPage: page.nextPage,
      fromCache: page.fromCache,
    );
  }
}

final newsProvider =
    AsyncNotifierProvider.family<NewsNotifier, NewsState, String>(
      NewsNotifier.new,
    );
