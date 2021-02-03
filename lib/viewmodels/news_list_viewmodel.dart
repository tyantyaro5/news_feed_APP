import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/seach_type.dart';
import 'package:news_feed/models/news_model.dart';
import 'package:news_feed/repository/news_repository.dart';

class NewsListViewModel extends ChangeNotifier {

  final NewsRepository _repository;

  NewsListViewModel({repository}): _repository = repository;

  SearchType _searchType = SearchType.CATEGORY;
  SearchType get searchType => _searchType;

  Category _category = categories[0];
  Category get category => _category;

  String _keyword = "";
  String get keyword => _keyword;

  LoadStatus _loadStatus = LoadStatus.DONE;
  LoadStatus get loadStatus => _loadStatus;

  List<Article> _articles = List();
  List<Article> get articles => _articles;

  Future<void> getNews({
    @required SearchType searchType, String keyword, Category category
  }) async{
    _searchType = searchType;
    _keyword = keyword;
    _category = category;

    _articles = await _repository.getNews(
      searchType: _searchType, keyword: _keyword, category: _category,);

  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  onRepositoryUpdated(NewsRepository repository) {
    _articles =_repository.articles;
    _loadStatus = _repository.loadStatus;
    notifyListeners();
  }
}