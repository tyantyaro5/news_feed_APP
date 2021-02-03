import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/seach_type.dart';
import 'package:news_feed/main.dart';
import 'package:news_feed/models/dao.dart';
import 'package:news_feed/models/database.dart';
import 'package:news_feed/models/news_model.dart';
import 'package:news_feed/networking/api_service.dart';
import 'package:provider/provider.dart';
import 'package:news_feed/util/extensions.dart';

class NewsRepository extends ChangeNotifier {
  final ApiService _apiService;
  final NewsDao _dao;

  NewsRepository({dao, apiService})
      : _apiService = apiService,
        _dao = dao;

  List<Article> _articles = List();
  List<Article> get articles => _articles;

  LoadStatus _loadStatus = LoadStatus.DONE;
  LoadStatus get loadStatus => _loadStatus;

  getNews({@required SearchType searchType,
      String keyword,
      Category category}) async {

    _loadStatus = LoadStatus.LOADING;
    notifyListeners();

    Response response;

    try {
      switch (searchType) {
        case SearchType.HEAD_LINE:
          response = await _apiService.getHeadLines();
          break;
        case SearchType.KEYWORD:
          response = await _apiService.getKeywordNews(keyword: keyword);
          break;
        case SearchType.CATEGORY:
          response =
              await _apiService.getCategoryNews(category: category.nameEn);
          break;
      }
      if (response.isSuccessful) {
        final responseBody = response.body;
        //result = News.fromJson(responseBody).articles;
        await insertAndReadFromDB(responseBody);
        notifyListeners();
      } else {
        final errorCode = response.statusCode;
        final error = response.error;
        _loadStatus = LoadStatus.RESPONSE_ERROR;
        print("response is not successful: $errorCode / $error");
      }
    } on Exception catch (error) {
      _loadStatus = LoadStatus.NETWORK_ERROR;
      print("error: $error");
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  insertAndReadFromDB(responseBody) async {
    final articlesFromNetwork = News.fromJson(responseBody).articles;

    //Webから取得した記事リスト（Article）をDBのテーブルクラス（Articles）に変換してDB登録・DBから取得
    final articlesFromDB =
        await _dao.insertAndReadNewsFromDB(articlesFromNetwork.toArticleRecords(articlesFromNetwork));

    //DBから取得したデータをモデルクラスに再変換して返す
    _articles = articlesFromDB.toArticles(articlesFromDB);
    _loadStatus = LoadStatus.DONE;
  }
}
