import 'package:flutter/material.dart';
import 'package:revisit/components/empty_value.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/components/article_explore_card.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/article.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/article_tab/article_detail.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard(
      this._parentState,
      );

  final dynamic _parentState;

  @override
  Widget build(BuildContext context) {
    return cardList;
  }

  Widget get cardList {
    if (_parentState.isLoading) return RevisitSpinner();

    if (_parentState.searchMode && !_parentState.isShowSearch)
      return Center(
        child: Padding(
          padding: EdgeInsets.all(
            Constant.MINIMUM_SPACING_LG,
          ),
          child: Text(
            'Cari',
            style: TextStyle(
              color: Constant.GRAY_TEXT,
              fontStyle: FontStyle.italic,
              fontSize: Constant.MINIMUM_FONT_SIZE,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

    if (_parentState.isShowSearch) return _searchResultElement;

    var isArticleEmpty = _parentState.articleService.articleExplore == null ||
        _parentState.articleService.articleExplore.isEmpty;

    var storeList = _parentState.articleService.articleExplore;

    if (storeList.isEmpty)
      return Container(
        padding: EdgeInsets.all(
          Constant.MINIMUM_PADDING_LG,
        ),
        child: Column(
          children: <Widget>[
            RevisitEmptyValues(
              'assets/images/empty-box.png',
              text: 'Tidak ada Artikel',
            ),
          ],
        ),
      );

    if (_parentState.isLoading) {
      return RevisitSpinner();
    }

    return _wrapperStoreExplores(
      _parentState.articleService.articleExplore,
    );
  }

  Widget _wrapperStoreExplores(List<Article> stories) {
    if (stories.isEmpty) return Container();
    print(stories);

    final size = MediaQuery.of(_parentState.context).size;

    int length = 0;
    if (stories == null || stories.isEmpty) {
      length = 0;
    } else {
      length = stories.length;
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.MINIMUM_PADDING_SM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: stories
            .map<Widget>(
              (article) => ArticleExploreCard(
            article: article,
            onPress: () => _onNavigateToDetail(article),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget get _searchResultElement {
    if (_parentState.isLoading) return RevisitSpinner();

    return Column(
      children: <Widget>[
        _wrapperStoreExplores(_parentState.articleService.articleSearchResult),
      ],
    );
  }

  void _onNavigateToDetail(Article article) {
    return MainPlatform.transitionToPage(
      _parentState.context,
      ArticleDetail(
        articleExplore: article,
      ),
    );
  }
}
