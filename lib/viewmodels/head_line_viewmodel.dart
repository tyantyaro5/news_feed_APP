import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/seach_type.dart';
import 'package:news_feed/models/news_model.dart';
import 'package:news_feed/repository/news_repository.dart';

class HeadLinViewModel extends ChangeNotifier {
  final NewsRepository _repository;

  HeadLinViewModel({repository}): _repository = repository;

  SearchType _searchType = SearchType.CATEGORY;
  SearchType get searchType => _searchType;

  List<Article> _articles = List();
  List<Article> get articles => _articles;

  LoadStatus _loadStatus = LoadStatus.DONE;
  LoadStatus get loadStatus => _loadStatus;

  @override
  void dispose() {
    // TODO: implement dispose
    _repository.dispose();
    super.dispose();
  }

  Future<void> getHeadLines({@required SearchType searchType}) async{
    _searchType = searchType;
    notifyListeners();

    _articles = await _repository .getNews(searchType: SearchType.HEAD_LINE);
    print("searchType: $_searchType / articles: ${_articles[0].title}");
  }

  onRepositoryUpdated(NewsRepository repository) {
    _articles = _repository.articles;
    _loadStatus = _repository.loadStatus;
    notifyListeners();
  }
}