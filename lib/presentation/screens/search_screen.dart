import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/core/constants.dart';
import 'package:dailyfeed/presentation/providers/news_provider.dart';
import 'package:dailyfeed/presentation/widgets/article_card.dart';
import 'package:dailyfeed/presentation/widgets/empty_view.dart';
import 'package:dailyfeed/presentation/widgets/error_view.dart';
import 'package:dailyfeed/presentation/widgets/loading_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConfig.searchDebounce, () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;
    final feed = hasQuery ? ref.watch(newsProvider(_query)) : null;
    final notifier = hasQuery ? ref.read(newsProvider(_query).notifier) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search news…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clear,
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
        ),
      ),
      body: !hasQuery
          ? const EmptyView(
              icon: Icons.travel_explore,
              title: 'Search for news',
              message: 'Type a title or keyword to get started.',
            )
          : feed!.when(
              loading: () => const LoadingView(),
              error: (error, _) =>
                  ErrorView(error: error, onRetry: notifier!.refresh),
              data: (state) {
                if (state.articles.isEmpty) {
                  return EmptyView(
                    icon: Icons.search_off,
                    title: 'No results for "$_query"',
                    message: 'Try different keywords.',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: state.articles.length,
                  itemBuilder: (_, i) =>
                      ArticleCard(article: state.articles[i]),
                );
              },
            ),
    );
  }
}
