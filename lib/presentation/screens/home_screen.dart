import 'package:dailyfeed/presentation/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyfeed/presentation/providers/news_provider.dart';
import 'package:dailyfeed/presentation/widgets/empty_view.dart';
import 'package:dailyfeed/presentation/widgets/error_view.dart';
import 'package:dailyfeed/presentation/widgets/loading_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(newsProvider('').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(newsProvider(''));
    final notifier = ref.read(newsProvider('').notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Stories'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.refresh,
          ),
        ],
      ),
      body: feed.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(error: error, onRetry: notifier.refresh),
        data: (state) {
          if (state.articles.isEmpty) {
            return RefreshIndicator(
              onRefresh: notifier.refresh,
              child: ListView(
                children: const <Widget>[
                  SizedBox(height: 200),
                  EmptyView(
                    icon: Icons.article_outlined,
                    title: 'No stories yet',
                    message: 'Pull down to refresh',
                  ),
                ],
              ),
            );
          }

          return Column(
            children: <Widget>[
              if (state.fromCache)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Offline — showing cached stories',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                    itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.articles.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ArticleCard(article: state.articles[index]);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
