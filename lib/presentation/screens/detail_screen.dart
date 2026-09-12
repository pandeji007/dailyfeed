import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailyfeed/domain/entities/article.dart';
import 'package:dailyfeed/presentation/providers/bookmark_provider.dart';
import 'package:dailyfeed/presentation/widgets/gradient_icon.dart';
import 'package:dailyfeed/presentation/widgets/gradient_text.dart';
import 'package:dailyfeed/presentation/widgets/link_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
            icon: bookmarked
                ? const GradientIcon(Icons.bookmark)
                : const Icon(Icons.bookmark_border),
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
                GradientText(
                  article.sourceName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
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
                Hyperlink(
                  url: article.sourceUrl.isNotEmpty
                      ? article.sourceUrl
                      : article.link,
                ),
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
                        .map(
                          (k) => Chip(
                            label: Text(k),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            side: BorderSide(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        )
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
