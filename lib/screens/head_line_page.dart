import 'package:flutter/material.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/seach_type.dart';
import 'package:news_feed/models/news_model.dart';
import 'package:news_feed/view/head_line_item.dart';
import 'package:news_feed/view/page_transformer.dart';
import 'package:provider/provider.dart';
import 'package:news_feed/viewmodels/head_line_viewmodel.dart';

import 'news_web_page_screen.dart';

class HeadLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeadLinViewModel>(context, listen: false);

    if (viewModel.loadStatus != LoadStatus.LOADING && viewModel.articles.isEmpty) {
      Future(() => viewModel.getHeadLines(searchType: SearchType.HEAD_LINE));
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<HeadLinViewModel>(
            builder: (context, model, child) {
              if (model.loadStatus == LoadStatus.LOADING) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PageTransformer(
                    pageViewBuilder: (context, pageVisibilityResolver) {
                  return PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: model.articles.length,
                    itemBuilder: (context, index) {
                      final article = model.articles[index];
                      final pageVisibility =
                          pageVisibilityResolver.resolvePageVisibility(index);
                      final visibleFraction = pageVisibility.visibleFraction;
                      return HeadLineItem(
                        article: model.articles[index],
                        pageVisibility: pageVisibility,
                        onArticleClicked: (article) =>
                            _openArticleWebPage(context, article),
                      );
                    },
                  );
                });
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () => onRefresh(context),
        ),
      ),
    );
  }

  //更新処理
  onRefresh(BuildContext context) async {
    print("HeadLinePage.onRefresh");
    final viewModel = Provider.of<HeadLinViewModel>(context, listen: false);
    await viewModel.getHeadLines(searchType: SearchType.HEAD_LINE);
  }

  _openArticleWebPage(BuildContext context, Article article) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsWebPageScreen(
              article: article,
            )));
  }
}
