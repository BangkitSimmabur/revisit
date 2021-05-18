import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/article_tab/article_Card.dart';
import 'package:revisit/screens/tabs/article_tab/article_search_bar.dart';
import 'package:revisit/screens/tabs/article_tab/create_artikel.dart';
import 'package:revisit/service/article_service.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/location_service.dart';

class ArticleMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticleMainState();
  }
}

class ArticleMainState extends State<ArticleMain> {
  AuthService authService;
  ArticleService articleService;
  LocationService locationService;
  var currentPage = 1;
  var currentSearchPage = 1;
  final focusNode = FocusNode();
  final searchController = TextEditingController();
  var isLoading = true;
  var canScroll = true;
  var canSearchProductScroll = true;
  var canSearchStoreScroll = true;
  var currentSumArticle = 0;
  var currentSumSearchStores = 0;
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

    await articleService.getAllArticle(currentPage, true);

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

    if (currentSumArticle >= articleService.articleExplore.length) {
      return setState(() => canScroll = false);
    }

    setState(
      () => currentSumArticle = articleService.articleExplore.length,
    );

    print(canScroll);
    print(currentSumArticle);

    return;
  }

  @override
  void setState(fn) {
    if (!mounted) return;

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    articleService = Provider.of<ArticleService>(context);
    authService = Provider.of<AuthService>(context);
    locationService = Provider.of<LocationService>(context);

    return Scaffold(
      body: Container(
        child: _childElement,
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
            child: ArticleSearchBar(this),
          ),
          Container(
            height: Constant.MINIMUM_SPACING_MD,
          ),
          ArticleCard(this),
          isBottomLoading ? RevisitSpinner() : Container(),
        ],
      ),
    );
  }

  void _toCreateArticle() {
    MainPlatform.transitionToPage(context, CreateArticle());
  }

  void _onRefresh() async {
    if (isShowSearch) {
      return onSearch();
    }

    setState(() {
      currentPage = 1;
      // storeSearchPagination.resetPagination();
      // productSearchPagination.resetPagination();
      currentSumArticle = 0;
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
      setState(() => currentSearchPage++);
      if (!canSearchStoreScroll) {
        return refreshController.loadNoData();
      }

      await articleService.getSearchArticle(
        keyWord: searchController.text,
        page: currentSearchPage,
        isNew: false,
      );

      if (currentSumSearchStores >= articleService.articleSearchResult.length) {
        setState(() => canSearchStoreScroll = false);
      }

      setState(
        () =>
            currentSumSearchStores = articleService.articleSearchResult.length,
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

    await articleService.getAllArticle(
      currentPage,
      false,
    );

    if (currentSumArticle >= articleService.articleExplore.length) {
      setState(() => canScroll = false);
    }

    setState(
      () => currentSumArticle = articleService.articleExplore.length,
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
        articleService.currentKeyWord = null;
      });
    }

    if (searchController.text != null || searchController.text.isNotEmpty)
      setState(() {
        searchMode = true;
        articleService.currentKeyWord = searchController.text;
      });

    if ((searchController.text != null || searchController.text.isNotEmpty) &&
        (articleService.articleSearchResult.isNotEmpty)) {
      return setState(() {
        searchMode = true;
        isShowSearch = true;
        articleService.currentKeyWord = searchController.text;
      });
    }
  }

  Future<void> onSearch() async {
    setState(() {
      searchMode = true;
      isLoading = true;
      currentSearchPage = 1;
      canSearchStoreScroll = true;
      canSearchProductScroll = true;
      articleService.currentKeyWord = searchController.text;
    });

    await articleService.getSearchArticle(
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
