import 'package:flutter/material.dart';
import 'package:newsapp/detail_page.dart';
import 'package:newsapp/news_list_page.dart';
import 'package:newsapp/model/article.dart';
import 'package:newsapp/article_webview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: NewsListPage.routeName,
      routes: {
        NewsListPage.routeName: (context) =>  const NewsListPage(),
        ArticleDetailPage.routeName: (context) => ArticleDetailPage(
          article: ModalRoute.of(context)?.settings.arguments as Article,
        ),
        ArticleWebView.routeName: (context) => ArticleWebView(
          url: ModalRoute.of(context)?.settings.arguments as String,
        ),
      },
    );
  }
}

