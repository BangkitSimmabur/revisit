import 'package:flutter/material.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/constant.dart';

class CreateArticle extends StatefulWidget {
  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
    );
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Registrasi',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
