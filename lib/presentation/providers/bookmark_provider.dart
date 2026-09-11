import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/data/models/article_model.dart';
import 'package:dailyfeed/data/services/storage_service.dart';
import 'package:dailyfeed/domain/entities/article.dart';

/// Whether a specific article is bookmarked.
final isBookmarkedProvider = Provider.family<bool, String>((ref, id) {
  final list = ref.watch(bookmarksProvider);
  return list.any((a) => a.id == id);
});

class BookmarksNotifier extends Notifier<List<Article>> {
  @override
  List<Article> build() {
    final box = StorageService.bookmarks;
    final list = <Article>[];
    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is Map) {
        try {
          list.add(
            ArticleModel.fromJson(Map<String, dynamic>.from(raw)).toEntity(),
          );
        } catch (_) {
          // skip corrupted entry
        }
      }
    }
    list.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return list;
  }

  Future<void> toggle(Article article) async {
    if (state.any((a) => a.id == article.id)) {
      await _remove(article.id);
    } else {
      await _add(article);
    }
  }

  Future<void> _add(Article article) async {
    await StorageService.bookmarks.put(
      article.id,
      ArticleModel.fromEntity(article).toJson(),
    );
    state = [article, ...state];
  }

  Future<void> _remove(String id) async {
    await StorageService.bookmarks.delete(id);
    state = state.where((a) => a.id != id).toList();
  }
}

final bookmarksProvider = NotifierProvider<BookmarksNotifier, List<Article>>(
  BookmarksNotifier.new,
);
