import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/image_input_common.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/input_map.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/article_service.dart';

class CreateArticle extends StatefulWidget {
  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  File _imageFile;
  bool _isLoading = false;
  bool _isLoadingImg = false;
  LocationData location;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  ArticleService _articleService;
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    location = new LocationData(null, null, "");

    super.initState();
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
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: _formElement,
              ),
            ),
            _createStoreBtn,
          ],
        )
      ],
    );
  }

  Widget get _formElement {
    return ListView(
      padding: EdgeInsets.all(Constant.DEFAULT_PADDING_VIEW),
      children: [
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
        RevisitInputCommon(
          'Judul Artikel',
          hintText: 'Judul Artikel',
          labelMinLine: 1,
          labelMaxLine: 3,
          isDense: true,
          inputController: _titleController,
          noLabel: true,
          labelColor: Colors.black,
        ),
        Container(
          height: Constant.MINIMUM_SPACING_LG,
        ),
        _photoIntput,
        Container(
          height: Constant.MINIMUM_SPACING_LG,
        ),
        _locationElement,
        Container(
          height: Constant.MINIMUM_SPACING_XLG,
        ),
        RevisitInputCommon(
          'Deskripsi',
          hintText: 'Deskripsi',
          labelMinLine: 3,
          labelMaxLine: 3,
          isDense: true,
          inputController: _descController,
          noLabel: true,
          labelColor: Colors.black,
        ),
      ],
    );
  }

  Widget get _locationElement {
    var isLocationExist = location.address.isNotEmpty;
    TextStyle _style = TextStyle(
      fontSize: Constant.MINIMUM_FONT_SIZE - 2,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: Constant.MINIMUM_SPACING * 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 50),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constant.MINIMUM_SPACING, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: isLocationExist
                          ? Text(
                        location.address,
                        style: _style,
                      )
                          : Text(
                        'Masukkan Lokasi',
                        style: _style,
                      )),
                  Container(
                    width: Constant.MINIMUM_SPACING,
                  ),
                  GestureDetector(
                    onTap: _onNavigateInputMap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Constant.GRAY_TEXT),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      child: Icon(
                        Icons.place,
                        color: Constant.GRAY_TEXT3,
                        size: Constant.MINIMUM_FONT_SIZE + 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _onNavigateInputMap() async {
    var data = await MainPlatform.transitionToPage(
      context,
      RevisitInputMap(
        initLocationData: location,
      ),
    );

    print(data);

    if (data == null) return;

    setState(() => location = data);
  }

  Widget get _createStoreBtn {
    return RevisitButtonFull(
      "BUAT CERITA",
      buttonColor: Constant.blue01,
      onClick: _onCreateArticle,
      isLoading: _isLoading,
      padding: Constant.MINIMUM_PADDING_BUTTON_MD,
      labelSize: Constant.MINIMUM_FONT_SIZE - 2,
    );
  }

  void _onCreateArticle() async {
    if (_titleController.text.isEmpty || _titleController.text == null) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Judul artikel tidak diisi',
        color: Constant.red01,
      );
      return;
    }

    if (_descController.text.isEmpty || _descController.text == null) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Isi artikel tidak diisi',
        color: Constant.red01,
      );
      return;
    }
    if (location.address == null || location.address.isEmpty) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Lokasi artikel tidak diisi',
        color: Constant.red01,
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    MainPlatform.showLoadingAlert(context, 'Membuat artikel');
    var serverLog = await _articleService.createArticle(
      title: _titleController.text,
      action: ItemAction.create,
      locationData: location,
      photo: _imageFile,
      text: _descController.text,
    );
    setState(() {
      _isLoading = false;
    });

    if(serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.backTransitionPage(context);
    }
    if(!serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.showErrorSnackbar(context, 'Gagal membuat artikel');
    }
  }

  Widget get _photoIntput {
    return RevisitInputImageCommon(
      null,
      onSavedImage: (File img) {
        _imageFile = img;
      },
      isLoading: _isLoadingImg,
    );
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Buat Artikel',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
