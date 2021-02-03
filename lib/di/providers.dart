import 'package:flutter/material.dart';
import 'package:news_feed/models/dao.dart';
import 'package:news_feed/models/database.dart';
import 'package:news_feed/networking/api_service.dart';
import 'package:news_feed/repository/news_repository.dart';
import 'package:news_feed/viewmodels/head_line_viewmodel.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List<SingleChildWidget> independentModels = [
  Provider<ApiService>(
      create: (_) => ApiService.create(),
    dispose: (_, apiService) => apiService.dispose(),
  ),
  Provider<MyDatabase>(
      create: (_) => MyDatabase(),
    dispose: (_, db) => db.close(),
  )
];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<MyDatabase, NewsDao>(
      update: (_, db, dao) => NewsDao(db),
  ),
  ChangeNotifierProvider<NewsRepository>(
    create: (context) => NewsRepository(
      dao: Provider.of<NewsDao>(context, listen: false),
      apiService: Provider.of<ApiService>(context, listen: false),
    ),
  )
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProxyProvider<NewsRepository, HeadLinViewModel>(
      create: (context) => HeadLinViewModel(
        repository: Provider.of<NewsRepository>(context, listen: false),
      ),
    update: (context, repository, viewModel) => viewModel..onRepositoryUpdated(repository),
  ),
  ChangeNotifierProxyProvider<NewsRepository, NewsListViewModel>(
      create: (context) => NewsListViewModel(
        repository: Provider.of<NewsRepository>(context, listen: false),
      ),
    update: (context, repository, viewModel) => viewModel..onRepositoryUpdated(repository),
  )
];