import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dailyfeed/domain/entities/article.dart';
import 'package:dailyfeed/presentation/providers/bookmark_provider.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarked = ref.watch(isBookmarkedProvider(article.id));
    final body = article.content.trim().isEmpty
        ? article.description
        : article.content;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                ref.read(bookmarksProvider.notifier).toggle(article),
            icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          if (article.imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(color: theme.colorScheme.surfaceContainerHighest),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  article.sourceName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat(
                    'EEEE, d MMM y • HH:mm',
                  ).format(article.publishedAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (article.creator.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'By ${article.creator}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  body,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
                if (article.keywords.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: article.keywords
                        .take(8)
                        .map((k) => Chip(label: Text(k)))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
