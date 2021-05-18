import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:revisit/Screens/tabs/story_tab/create_story.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/story_tab/story_card.dart';
import 'package:revisit/screens/tabs/story_tab/story_search_bar.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/service/story_service.dart';

class StoryMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StoryMainState();
  }
}

class StoryMainState extends State<StoryMain> {
  AuthService authService;
  StoryService storyService;
  LocationService locationService;
  var currentPage = 1;
  var currentSearchPage = 1;
  final focusNode = FocusNode();
  final searchController = TextEditingController();
  var isLoading = true;
  var canScroll = true;
  var canSearchProductScroll = true;
  var canSearchStoreScroll = true;
  var currentSumStory = 0;
  var currentSumStorySearch = 0;
  var currentKeyword;
  var searchMode = false;
  var isShowSearch = false;
  bool isBottomLoading = false;

  final refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.canLoading,
  );
  final scrollController = ScrollController();

  @override
  void dispose() {
    focusNode.dispose();
    searchController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, initDataState);

    searchController.addListener(_onChangeSearch);

    super.initState();
  }

  Future initDataState({
    bool isMainLoading = true,
  }) async {
    if (!isMainLoading && !canScroll) return;

    if (isMainLoading) setState(() => isLoading = true);

    await storyService.getAllStory(
      currentPage,
      true
    );

    // if (storyService.currentKeyWord != null &&
    //     storyService.currentKeyWord.isNotEmpty) {
    //   setState(() {
    //     searchMode = true;
    //     isShowSearch = true;
    //   });
    //
    //   if (storyService.currentKeyWord != null &&
    //       storyService.currentKeyWord.isNotEmpty) {
    //     setState(
    //           () => searchController.text = storyService.currentKeyWord,
    //     );
    //   }
    //
    //   await storeService.searchGetAllStore(
    //     keyword: searchController.text,
    //     catIds: storeService.storeCategories,
    //     tag: storeService.selectedTag,
    //     byLocation: storeService.searchByLocation,
    //     pagination: storeSearchPagination,
    //   );
    //
    //   await menuItemService.searchGetAllProduct(
    //     keyword: searchController.text,
    //     catIds: storeService.storeCategories,
    //     tag: storeService.selectedTag,
    //     byLocation: storeService.searchByLocation,
    //     pagination: productSearchPagination,
    //   );
    // }

    if (isMainLoading) setState(() => isLoading = false);

    if (currentSumStory >= storyService.storyExplore.length) {
      return setState(() => canScroll = false);
    }

    setState(
      () => currentSumStory = storyService.storyExplore.length,
    );

    return;
  }

  @override
  void setState(fn) {
    if (!mounted) return;

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    storyService = Provider.of<StoryService>(context);
    authService = Provider.of<AuthService>(context);
    locationService = Provider.of<LocationService>(context);

    return Scaffold(
      body: Container(
        child: _childElement,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toCreateStory();
        },
        child: Icon(Icons.add),
        backgroundColor: Constant.blue01,
      ),
    );
  }

  Widget get _childElement {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onCheckEndScroll,
      footer: ClassicFooter(
        idleText: 'Tarik ke atas untuk memuat lebih banyak',
        idleIcon: Icon(
          Icons.keyboard_arrow_up,
        ),
        loadingText: 'Memuat data',
        noDataText: 'Tidak ada data',
        canLoadingText: 'Lepaskan untuk memuat lebih banyak',
        failedText: 'Gagal memuat data',
      ),
      child: ListView(
        controller: scrollController,
        children: [
          Container(
            height: Constant.MINIMUM_SPACING_MD,
          ),
          Container(
            child: StorySearchBar(this),
          ),
          Container(
            height: Constant.MINIMUM_SPACING_MD,
          ),
          StoryCard(this),
          isBottomLoading ? RevisitSpinner() : Container(),
        ],
      ),
    );
  }

  void _toCreateStory() {
    MainPlatform.transitionToPage(context, CreateStory());
  }

  void _onRefresh() async {
    if (isShowSearch) {
      return onSearch();
    }

    setState(() {
      currentPage = 1;
      currentSearchPage = 1;
      currentSumStory = 0;
      canScroll = true;
    });

    await initDataState();

    return refreshController.refreshCompleted(
      resetFooterState: true,
    );
  }

  void _onCheckEndScroll() async {
    setState(() {
      isBottomLoading = true;
    });
    if (isShowSearch) {

      setState(() => currentSearchPage ++);
      if (!canSearchStoreScroll) {
        return refreshController.loadNoData();
      }

      await storyService.getSearchStory(
        keyWord: searchController.text,
        page: currentSearchPage,
        isNew: false,
      );

      if (currentSumStorySearch >= storyService.storySearchResult.length) {
        setState(() => canSearchStoreScroll = false);
      }

      setState(
            () => currentSumStorySearch = storyService.storySearchResult.length,
      );

      if (canSearchStoreScroll) {
        return refreshController.loadComplete();
      }

      return refreshController.loadNoData();
    }

    setState(() => currentPage++);
    if (!canScroll) {
      return refreshController.loadNoData();
    }

    await storyService.getAllStory(
      currentPage,
      false,
    );

    if (currentSumStory >= storyService.storyExplore.length) {
      setState(() => canScroll = false);
    }

    setState(
          () => currentSumStory = storyService.storyExplore.length,
    );

    setState(() {
      isBottomLoading = false;
    });

    if (canScroll) {
      return refreshController.loadComplete();
    }

    return refreshController.loadNoData();
  }

  Future<void> _onChangeSearch() async {
    if ((searchController.text == null ||
        searchController.text == '' ||
        searchController.text.isEmpty)) {
      return setState(() {
        searchMode = false;
        isShowSearch = false;
        storyService.currentKeyWord = null;
      });
    }

    if (searchController.text != null || searchController.text.isNotEmpty)
      setState(() {
        searchMode = true;
        storyService.currentKeyWord = searchController.text;
      });

    if ((searchController.text != null || searchController.text.isNotEmpty) &&
        (storyService.storySearchResult.isNotEmpty)) {
      return setState(() {
        searchMode = true;
        isShowSearch = true;
        storyService.currentKeyWord = searchController.text;
      });
    }
  }

  Future<void> onSearch() async {
    setState(() {
      searchMode = true;
      isLoading = true;
currentSearchPage = 1;      currentSumStorySearch = 0;
      canSearchStoreScroll = true;
      canSearchProductScroll = true;
      storyService.currentKeyWord = searchController.text;
    });

    await storyService.getSearchStory(
      keyWord: searchController.text,
      page: currentSearchPage,
      isNew: true,
    );

    return setState(() {
      searchMode = true;
      isLoading = false;
      isShowSearch = true;
      refreshController.refreshCompleted(
        resetFooterState: true,
      );
    });
  }
}
