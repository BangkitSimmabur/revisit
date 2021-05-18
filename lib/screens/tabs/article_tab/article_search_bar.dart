import 'package:flutter/material.dart';
import 'package:revisit/components/revisit_search_bar.dart';
import 'package:revisit/screens/tabs/article_tab/article_main.dart';

class ArticleSearchBar extends StatelessWidget {
  ArticleSearchBar(
      this._parentState,
      );

  final dynamic _parentState;

  @override
  Widget build(BuildContext context) {
    return _searchBar;
  }

  Widget get _searchBar {
    return RevisitSearchBar(
      'Judul artikel',
      isIntl: true,
      searchBarController: _parentState.searchController,
      focusNode: _parentState.focusNode,
      onSearchSubmit: (String val) => _onSearchQuery(val),
    );
  }

  Future<void> _onSearchQuery(String val) async {
    _parentState.focusNode.unfocus();
    if ((val.isEmpty || val == '')) {
      // ignore: invalid_use_of_protected_member
      return _parentState.setState(() {
        _parentState.searchMode = false;
        _parentState.isShowSearch = false;
      });
    }

    if (_parentState.searchMode && _parentState.currentKeyword == val) return;

    // ignore: invalid_use_of_protected_member
    _parentState.setState(() {
      _parentState.searchMode = true;
      _parentState.isLoading = true;
      _parentState.articleService.currentKeyWord = val;
      _parentState.currentSearchPage = 1;
      _parentState.currentSumSearchStores = 0;
      _parentState.canSearchStoreScroll = true;
      _parentState.canSearchProductScroll = true;
    });

    await _parentState.articleService.getSearchArticle(
      keyWord: val,
      page: _parentState.currentSearchPage,
      isNew: true,
    );

    // ignore: invalid_use_of_protected_member
    return _parentState.setState(() {
      _parentState.searchMode = true;
      _parentState.isLoading = false;
      _parentState.isShowSearch = true;
      _parentState.refreshController.refreshCompleted(
        resetFooterState: true,
      );
    });
  }
}
