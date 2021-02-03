import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/seach_type.dart';
import 'package:news_feed/screens/news_web_page_screen.dart';
import 'package:news_feed/view/article_tile.dart';
import 'package:news_feed/view/category_chips.dart';
import 'package:news_feed/view/search_bar.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if (viewModel.loadStatus != LoadStatus.LOADING &&
        viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(
          searchType: SearchType.CATEGORY, category: categories[0]));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          tooltip: "更新",
          onPressed: () => onRefresh(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchBar(
                onSearch: (keyword) => getKeywordNews(context, keyword),
              ),
              CategoryChips(
                onCategorySelected: (category) =>
                    getCategoryNews(context, category),
              ),
              Expanded(child:
                  Consumer<NewsListViewModel>(builder: (context, model, child) {
                if (model.loadStatus == LoadStatus.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: model.articles.length,
                      itemBuilder: (context, int position) => ArticleTile(
                            article: model.articles[position],
                            onArticleClicked: (article) =>
                                _openArticleWebPage(article, context),
                          ));
                }
              })),
            ],
          ),
        ),
      ),
    );
  }

  //記事更新処理
  Future<void> onRefresh(BuildContext context) async {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
    await viewModel.getNews(
      searchType: viewModel.searchType,
      keyword: viewModel.keyword,
      category: viewModel.category,
    );
  }

  //キーワード記事取得処理
  Future<void> getKeywordNews(BuildContext context, keyword) async {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
    await viewModel.getNews(
      searchType: SearchType.KEYWORD,
      keyword: keyword,
      category: categories[0],
    );
  }

  //カテゴリー記事取得処理
  Future<void> getCategoryNews(BuildContext context, Category category) async {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);
    await viewModel.getNews(
      searchType: SearchType.CATEGORY,
      category: category,
    );
  }

  _openArticleWebPage(article, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsWebPageScreen(
              article: article,
            )));
  }
}
