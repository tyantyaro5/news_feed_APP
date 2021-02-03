import 'package:flutter/material.dart';
import 'package:news_feed/models/news_model.dart';
import 'package:news_feed/style/style.dart';

class ArticleTileDesc extends StatelessWidget {
  final Article article;
  const ArticleTileDesc({this.article});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    var displayDesc = "";
    if (article.description != null){
      displayDesc = article.description;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(article.title, style: textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.bold
        ),),
        const SizedBox(height: 2.0,),
        Text(article.publishDate, style: textTheme.overline.copyWith(
          fontStyle: FontStyle.italic
        ),),
        const SizedBox(height: 2.0,),
        Text(displayDesc, style: textTheme.bodyText1.copyWith(
          fontFamily: RegularFont
        ),)
      ],
    );
  }
}
