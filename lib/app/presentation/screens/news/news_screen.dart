import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/blocs/news/news_bloc.dart';
import 'package:new_chat_app/app/presentation/screens/news/local_widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _scrollController = ScrollController();

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) context.read<NewsBloc>().add(FetchNews());
  }

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(FetchNews());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          
          centerTitle: true,
          title: const Text('Top headlines in United States'),
        ),
        body: Center(
            child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.status) {
              case NewsStatus.failure:
                return const Center(child: Text('failed to fetch news'));
              case NewsStatus.success:
                if (state.news.isEmpty) {
                  return const Center(child: Text('no posts'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax ? state.news.length : state.news.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.news.length
                        ? const Center(child: SizedBox(child: CircularProgressIndicator()))
                        : NewsCard(
                            news: state.news[index],
                          );
                  },
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        )),
      ),
    );
  }
}
