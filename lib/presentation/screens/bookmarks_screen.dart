import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/presentation/providers/bookmark_provider.dart';
import 'package:dailyfeed/presentation/widgets/article_card.dart';
import 'package:dailyfeed/presentation/widgets/empty_view.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: bookmarks.isEmpty
          ? const EmptyView(
              icon: Icons.bookmark_border,
              title: 'No saved articles',
              message: 'Tap the bookmark icon on any article to save it here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: bookmarks.length,
              itemBuilder: (_, i) => Dismissible(
                key: ValueKey(bookmarks[i].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                onDismissed: (_) =>
                    ref.read(bookmarksProvider.notifier).toggle(bookmarks[i]),
                child: ArticleCard(article: bookmarks[i]),
              ),
            ),
    );
  }
}
