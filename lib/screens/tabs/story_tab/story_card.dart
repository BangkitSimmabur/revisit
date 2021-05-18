import 'package:flutter/material.dart';
import 'package:revisit/components/empty_value.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/components/story_explore_card.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/story.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/story_tab/story_detail.dart';

class StoryCard extends StatelessWidget {
  StoryCard(
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

    var isStoryEmpty = _parentState.storyService.storyExplore == null ||
        _parentState.storyService.storyExplore.isEmpty;

    var storeList = _parentState.storyService.storyExplore;

    if (storeList.isEmpty)
      return Container(
        padding: EdgeInsets.all(
          Constant.MINIMUM_PADDING_LG,
        ),
        child: Column(
          children: <Widget>[
            RevisitEmptyValues(
              'assets/images/empty-box.png',
              text: 'Tidak ada Cerita',
            ),
          ],
        ),
      );

    if (_parentState.isLoading) {
      return RevisitSpinner();
    }

    return _wrapperStoreExplores(
      _parentState.storyService.storyExplore,
    );
  }

  Widget _wrapperStoreExplores(List<Story> stories) {
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
              (story) => StoryExploreCard(
                story: story,
                onPress: () => _onNavigateToDetail(story),
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
        _wrapperStoreExplores(_parentState.storyService.storySearchResult),
      ],
    );
  }

  void _onNavigateToDetail(Story story) {
    return MainPlatform.transitionToPage(
      _parentState.context,
      StoryDetail(
        storyExplore: story,
      ),
    );
  }
}
