import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/screens/tabs/profile_tab/edit_article.dart';
import 'package:revisit/service/article_service.dart';

class MyArticle extends StatefulWidget {
  @override
  _MyArticleState createState() => _MyArticleState();
}

class _MyArticleState extends State<MyArticle> {
  ArticleService _articleService;
  bool isBottomLoading = false;
  var isLoading = true;
  var canScroll = true;
  var currentSumArticle = 0;
  var currentPage = 1;
  final refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.canLoading,
  );
  final scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, initDataState);

    super.initState();
  }

  Future initDataState({
    bool isMainLoading = true,
  }) async {
    if (!isMainLoading && !canScroll) return;

    if (isMainLoading) setState(() => isLoading = true);

    await _articleService.getMyArticle(currentPage, true);

    if (isMainLoading) setState(() => isLoading = false);

    if (currentSumArticle >= _articleService.myArticle.length) {
      return setState(() => canScroll = false);
    }

    setState(
          () => currentSumArticle = _articleService.myArticle.length,
    );

    return;
  }

  @override
  Widget build(BuildContext context) {
    _articleService = Provider.of<ArticleService>(context);

    return Scaffold(
      appBar: _appBar,
      body: _childElement,
    );
  }

  Widget get _childElement {
    if (isLoading) {
      return RevisitSpinner();
    }

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
      child: ListView.builder(
        itemCount: _articleService.myArticle.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              child: ListTile(
                title: Text(
                  _articleService.myArticle[index].title,
                  style: TextStyle(
                    fontSize: Constant.MINIMUM_FONT_SIZE,
                    color: Constant.GRAY_TEXT,
                  ),
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(child: Text("Sunting"), value: "edit"),
                    PopupMenuItem(child: Text("hapus"), value: "delete"),
                  ],
                  onSelected: (val) {
                    print(val);
                    if (val == "edit") {
                      MainPlatform.transitionToPage(context,
                          EditArticle(id: _articleService.myArticle[index].id));
                    }

                    if (val == "delete") {
                      _onDeleteArticle(_articleService.myArticle[index].id);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    setState(() {
      currentPage = 1;
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

    setState(() => currentPage++);
    if (!canScroll) {
      return refreshController.loadNoData();
    }

    await _articleService.getMyArticle(
      currentPage,
      false,
    );

    if (currentSumArticle >= _articleService.myArticle.length) {
      setState(() => canScroll = false);
    }

    setState(
          () => currentSumArticle = _articleService.myArticle.length,
    );

    setState(() {
      isBottomLoading = false;
    });

    if (canScroll) {
      return refreshController.loadComplete();
    }

    return refreshController.loadNoData();
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Artikel Saya',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }

  Future<void> _onDeleteArticle(String id) async {
    var isAccept = await MainPlatform.showConfirmationAlert(
      context,
      Text(
        'Hapus Artikel',
      ),
      Text(
        'Anda yakin?',
      ),
    );

    if (isAccept != ConfirmAction.ACCEPT) {
      return MainPlatform.showErrorSnackbar(context, 'Menghapus artikel dibatalkan');
    }

    MainPlatform.showLoadingAlert(context, "Menghapus artikel.");
    var serverLog = await _articleService.deleteArticle(id);

    MainPlatform.backTransitionPage(context);
    if (serverLog.success) {
      setState(() {
        _articleService.myArticle.removeWhere((element) => element.id == id);
      });
      MainPlatform.showSuccessSnackbar(context, "Artikel berhasil dihapus.");
    }
    if (!serverLog.success) {
      MainPlatform.showErrorSnackbar(context, "Artikel gagal dihapus");
    }
  }
}
