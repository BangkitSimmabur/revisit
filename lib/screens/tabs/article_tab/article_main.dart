import 'package:flutter/material.dart';
import 'package:revisit/Screens/tabs/article_tab/create_artikel.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';

class ArticleMain extends StatefulWidget {
  @override
  _ArticleMainState createState() => _ArticleMainState();
}

class _ArticleMainState extends State<ArticleMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Text(
          "Article"
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toCreateArticle();
        },
        child: Icon(Icons.add),
        backgroundColor: Constant.blue01,
      ),
    );
  }

  void _toCreateArticle() {
    MainPlatform.transitionToPage(context, CreateArticle());
  }
}
