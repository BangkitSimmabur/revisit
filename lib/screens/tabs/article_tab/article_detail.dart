import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_common.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/detail_map_element.dart';
import 'package:revisit/components/image_placeholder.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/input_border.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/comment.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/models/article.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/auth_service.dart';
import 'package:revisit/service/article_service.dart';
import 'package:revisit/utility/like_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetail extends StatefulWidget {
  final Article articleExplore;

  ArticleDetail({
    @required this.articleExplore,
  });

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  ArticleV2 article;
  ArticleService articleService;
  AuthService authService;
  bool isLiked;
  bool isLoading = true;
  int likeCount = 0;
  List<Comments> articleComments = [];
  TextEditingController _commentController = TextEditingController();
  bool isTextEmpty = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, initDataState);

    // searchController.addListener(_onChangeSearch);

    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future initDataState() async {
    await articleService.getArticleById(widget.articleExplore.id);

    var like = LikeUtils().checkIfLiked(
      articleService.currentArticleV2.likes,
      authService.currentUser.id,
    );

    setState(() {
      isLiked = like;
      likeCount = articleService.currentArticleV2.likes.length;
      isLoading = false;
      articleComments = articleService.currentArticleV2.comments;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    articleService = Provider.of<ArticleService>(context);
    authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: _childElement,
      ),
    );
  }

  Widget get _childElement {
    if (isLoading) {
      return RevisitSpinner();
    }
    return Column(
      children: [
        _mapComponent,
        RevisitImgPlaceHolder(
          imgSrc: articleService.currentArticleV2.picture,
          fit: BoxFit.cover,
        ),
        _locationElement,
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
        _descElement,
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
        _likeReportElement,
        Container(
          height: Constant.MINIMUM_SPACING_MD * 2,
        ),
        Container(
          height: Constant.MINIMUM_DIVIDER_WIDTH,
          color: Constant.GRAY_TEXT,
        ),
        Container(
          height: Constant.MINIMUM_SPACING_MD * 2,
        ),
        _commentField,
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
        _commentButton,
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
        commentListSection,
      ],
    );
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Detail Artikel',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }

  Widget get _mapComponent {
    if (articleService.currentArticleV2.location == null) {
      return Container();
    }

    return DetailMapElement(articleService.currentArticleV2.location);
  }

  Widget get _locationElement {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constant.MINIMUM_SPACING_SM,
      ),
      child: GestureDetector(
        onTap: () {
          _onMapPressed(articleService.currentArticleV2.location);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.place,
              color: Constant.GRAY_TEXT,
              size: Constant.MINIMUM_FONT_SIZE + 6,
            ),
            Container(
              width: Constant.MINIMUM_SPACING,
            ),
            Text(
              articleService.currentArticleV2.location.address,
              style: TextStyle(
                fontSize: Constant.MINIMUM_FONT_SIZE_XS,
                color: Constant.GRAY_TEXT,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _descElement {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.MINIMUM_SPACING_SM),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            Constant.MINIMUM_SPACING_MD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                articleService.currentArticleV2.text,
                style: TextStyle(
                  fontSize: Constant.MINIMUM_FONT_SIZE,
                  color: Constant.GRAY_TEXT,
                ),
                textAlign: TextAlign.justify,
              ),
              Container(
                height: Constant.MINIMUM_SPACING_SM,
              ),
              Text(
                articleService.currentArticleV2.createdAt,
                style: TextStyle(
                  fontSize: Constant.MINIMUM_FONT_SIZE_XS,
                  color: Constant.GRAY_TEXT,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _likeReportElement {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constant.MINIMUM_SPACING_SM + Constant.MINIMUM_SPACING,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _onLikePressed(),
            child: Row(
              children: [
                isLiked
                    ? Icon(
                        Icons.thumb_up,
                        color: Constant.blue01,
                        size: Constant.MINIMUM_FONT_SIZE + 6,
                      )
                    : Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Constant.GRAY_TEXT,
                        size: Constant.MINIMUM_FONT_SIZE + 6,
                      ),
                Container(
                  width: Constant.MINIMUM_SPACING,
                ),
                Text(
                  likeCount.toString(),
                  style: TextStyle(
                    fontSize: Constant.MINIMUM_FONT_SIZE,
                    color: Constant.GRAY_TEXT,
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: _onReport,
            child: Icon(
              Icons.report,
              color: Colors.black,
              size: Constant.MINIMUM_FONT_SIZE_SM + 6,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onMapPressed(LocationData loc) async {
    if (await canLaunch(
        'http://maps.google.com/?q={${loc.latitude},${loc.longitude}')) {
      await launch('http://maps.google.com/?q=1.143532,104.002419');
    } else {
      throw 'Tidak dapat membuka peta lokasi';
    }
  }

  Future<void> _onLikePressed() async {
    MainPlatform.showLoadingAlert(
        context, !isLiked ? "Menyukai artikel" : "Tidak menyukai artikel");

    var serverLog =
        await articleService.likeArticle(articleService.currentArticleV2.id);

    if (serverLog.success) {
      setState(() {
        isLiked = !isLiked;
      });
      if (isLiked) {
        likeCount++;
      }
      if (!isLiked) {
        likeCount = likeCount - 1;
      }
    }

    MainPlatform.backTransitionPage(context);
    return;
  }

  Widget get _commentField {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.MINIMUM_PADDING_MD),
      child: RevisitInputOutlineBorder(
        'komentar',
        labelColor: Constant.GRAY_TEXT,
        labelSize: Constant.MINIMUM_FONT_SIZE,
        labelWeight: FontWeight.w600,
        keyboardType: TextInputType.multiline,
        borderSide: BorderSide(
          color: Constant.blue01,
          width: Constant.MINIMUM_BORDER_WIDTH,
        ),
        noPadding: true,
        inputController: _commentController,
        borderRadius: 50,
        onChange: (val) {
          if (val == "") {
            setState(() {
              isTextEmpty = true;
            });
          }
          if (val != "") {
            setState(() {
              isTextEmpty = false;
            });
          }
        },
      ),
    );
  }

  Widget get _commentButton {
    if (isTextEmpty) {
      return Container();
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constant.MINIMUM_PADDING * 2),
      child: RevisitButtonFull(
        "Tulis komentar",
        buttonColor: Constant.blue01,
        onClick: _onCreateComment,
        padding: Constant.MINIMUM_PADDING_BUTTON_MD,
        labelSize: Constant.MINIMUM_FONT_SIZE - 2,
        borderRadius: 50,
      ),
    );
  }

  Future<void> _onCreateComment() async {
    MainPlatform.showLoadingAlert(context, "Membuat komentar");

    var serverLog = await articleService.createComment(
      articleService.currentArticleV2.id,
      _commentController.text,
    );
    print(serverLog.success);
    print(serverLog.message);

    if (serverLog.success) {
      Comment newComment = new Comment(
        authService.currentUser,
        'Baru saja',
        _commentController.text,
      );

      Comments newComments = new Comments(
        serverLog.data["_id"],
        newComment,
        articleService.currentArticleV2.id,
        null,
      );
      setState(() {
        articleComments = [
          newComments,
          ...articleComments,
        ];
      });
    }

    MainPlatform.backTransitionPage(context);
    return;
  }

  Widget get commentListSection {
    if (articleComments.isEmpty) {
      return Container();
    }

    return Column(
      children: articleComments
          .map<Widget>(
            (comment) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constant.MINIMUM_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: comment.comments.user.profilePicture
                                    .thumbnailImage !=
                                null
                            ? Image.network(
                                comment.comments.user.profilePicture
                                    .thumbnailImage,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/placeholder_image.png',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                      ),
                      Container(
                        width: Constant.MINIMUM_SPACING,
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: comment.comments.user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: Constant.MINIMUM_FONT_SIZE,
                                ),
                              ),
                              TextSpan(
                                text: ' ${comment.comments.comment}',
                                style: TextStyle(
                                  color: Constant.GRAY_TEXT,
                                  fontSize: Constant.MINIMUM_FONT_SIZE_XS,
                                ),
                              ),
                            ],
                          ),
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: Constant.MINIMUM_SPACING,
                  ),
                  Text(
                    comment.comments.createdAt,
                    style: TextStyle(
                      fontSize: Constant.MINIMUM_FONT_SIZE_XS - 2,
                      color: Constant.GRAY_TEXT,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  Container(
                    height: Constant.MINIMUM_SPACING_MD,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _onReport() async {

    await showDialog(
        context: context,
        builder: (_) => ArticleReportDialog());
  }
}

class ArticleReportDialog extends StatefulWidget {

  @override
  _ArticleReportDialogState createState() => _ArticleReportDialogState();
}

class _ArticleReportDialogState extends State<ArticleReportDialog> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _reportController = TextEditingController();
  ArticleService _articleService;

  @override
  Widget build(BuildContext context) {
    _articleService = Provider.of<ArticleService>(context);

    return AlertDialog(
      title: titleWidget,
      content: subtitleWidget,
      actions: <Widget>[
        RevisitButtonCommon(
          'tutup',
          labelColor: Constant.blue01,
          color: Colors.white,
          onPress: () {
            _onCanceled();
          },
        ),
        RevisitButtonCommon(
          'lanjutkan',
          labelColor: Colors.white,
          color: Constant.blue01,
          onPress: () {
            _onReportArticle();
          },
        ),
      ],
    );
  }

  Widget get subtitleWidget {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: _titleInput,
        ),
        Material(
          color: Colors.transparent,
          child: _reportInput,
        ),
      ],
    );
  }

  Widget get titleWidget {
    return Text(
      'Laporkan Artikel',
    );
  }

  Widget get _reportInput {
    return Column(
      children: <Widget>[
        Container(
          height: Constant.MINIMUM_SPACING_MD,
        ),
        RevisitInputCommon(
          "Isi laporan",
          hintText: "Isi laporan",
          inputController: _reportController,
          labelColor: Colors.black,
          isDense: true,
          labelMaxLine: 4,
          labelMinLine: 1,
          keyboardType: TextInputType.multiline,
          labelSize: Constant.MINIMUM_FONT_SIZE - 2,
          noPadding: true,
          noLabel: true,
        ),
      ],
    );
  }

  Widget get _titleInput {
    return Column(
      children: <Widget>[
        Container(
          height: Constant.MINIMUM_SPACING_MD,
        ),
        RevisitInputCommon(
          "Nama laporan",
          hintText: "Nama laporan",
          inputController: _titleController,
          isDense: true,
          labelColor: Colors.black,
          labelMaxLine: 4,
          labelMinLine: 1,
          keyboardType: TextInputType.text,
          labelSize: Constant.MINIMUM_FONT_SIZE - 2,
          noPadding: true,
          noLabel: true,
        ),
      ],
    );
  }

  Widget get _confirmInput {
    return Column(
      children: <Widget>[
        Container(
          height: Constant.MINIMUM_SPACING_MD,
        ),
        Row(
          children: <Widget>[
            RevisitButtonCommon(
              'tutup',
              labelColor: Constant.BLUE03,
              color: Colors.white,
              onPress: () {
                Navigator.pop(context, ConfirmAction.CANCEL);
              },
            ),
            RevisitButtonCommon(
              'lanjutkan',
              labelColor: Colors.white,
              color: Constant.BLUE03,
              onPress: () {
                _onReportArticle();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onReportArticle() async {
    if (_reportController.text == "" || _titleController.text == "") {
      MainPlatform.showErrorSnackbar(
        context,
        "Isikan kolom judul dan isi laporan",
      );
      return;
    }

    if (_reportController.text != "" && _titleController.text != "") {
      MainPlatform.showLoadingAlert(context, 'Melaporkan Artikel');

      var serverLog = await _articleService.reportArticle(
        _articleService.currentArticleV2.id,
        _titleController.text,
        _reportController.text,
      );

      if (serverLog.success) {
        MainPlatform.backTransitionPage(context);
        MainPlatform.backTransitionPage(context);
        MainPlatform.showSuccessSnackbar(context, 'Artikel dilaporkan');
        return;
      }

      if (!serverLog.success) {
        MainPlatform.backTransitionPage(context);
        MainPlatform.showErrorSnackbar(
          context,
          "Gagal melaporkan artikel",
        );
      }
    }
  }

  Future<void> _onCanceled() async {
    Navigator.pop(context);
    await MainPlatform.showErrorSnackbar(
      context,
      "Dibatalkan",
    );
  }
}