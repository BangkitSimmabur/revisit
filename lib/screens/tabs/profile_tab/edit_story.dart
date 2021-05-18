import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/components/image_input_common.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/input_map.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/story_service.dart';

class EditStory extends StatefulWidget {
  final String id;

  EditStory({this.id});
  @override
  _EditStoryState createState() => _EditStoryState();
}

class _EditStoryState extends State<EditStory> {
  File _imageFile;
  String _imgSrc;
  bool _isLoading = false;
  bool _isLoadingImg = false;
  LocationData location = new LocationData(null, null, "");
  bool canUpdate = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  StoryService _storyService;
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, initDataState);

    super.initState();
  }

  Future initDataState() async {
    setState(() {
      _isLoading = true;
    });

    await _storyService.getStoryById(widget.id);
    setState(() {
      _titleController.text = _storyService.currentStoryV2.title;
      _descController.text = _storyService.currentStoryV2.text;
      location = _storyService.currentStoryV2.location;
      _imgSrc = _storyService.currentStoryV2.picture.fullImage;
    });
    setState(() {
      _isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    _storyService = Provider.of<StoryService>(context);

    return Scaffold(
      appBar: _appBar,
      body: _childElement,
    );
  }

  Widget get _childElement {
    if (_isLoading) {
      return RevisitSpinner();
    }

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
          'Judul Cerita',
          hintText: 'Judul Cerita',
          labelMinLine: 1,
          labelMaxLine: 3,
          isDense: true,
          inputController: _titleController,
          noLabel: true,
          labelColor: Colors.black,
          onChange: (val) {
            _onCheckCanUpdate();
          },
        ),
        Container(
          height: Constant.MINIMUM_SPACING_LG,
        ),
        _photoInput,
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
          onChange: (val) {
            _onCheckCanUpdate();
          },
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
        isNew: false,
      ),
    );

    if (data == null) return;

    setState(() => location = data);
    _onCheckCanUpdate();
  }

  Widget get _createStoreBtn {
    return RevisitButtonFull(
      "SUNTING CERITA",
      buttonColor: Constant.blue01,
      onClick: canUpdate ? _onUpdateStory : null,
      isLoading: _isLoading,
      padding: Constant.MINIMUM_PADDING_BUTTON_MD,
      labelSize: Constant.MINIMUM_FONT_SIZE - 2,
    );
  }

  void _onUpdateStory() async {
    if (_titleController.text.isEmpty || _titleController.text == null) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Judul cerita tidak diisi',
        color: Constant.red01,
      );
      return;
    }

    if (_descController.text.isEmpty || _descController.text == null) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Isi cerita tidak diisi',
        color: Constant.red01,
      );
      return;
    }
    if (location.address == null || location.address.isEmpty) {
      MainPlatform.showFloatingSnackbar(
        context,
        'Lokasi cerita tidak diisi',
        color: Constant.red01,
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    MainPlatform.showLoadingAlert(context, 'Menyunting cerita');
    await _storyService.updateStory(
      id: _storyService.currentStoryV2.id,
      context: context,
      title: _titleController.text,
      locationData: location,
      photo: _imageFile,
      text: _descController.text,
    );
  }

  Widget get _photoInput {
    return RevisitInputImageCommon(
      _imgSrc,
      onSavedImage: (File img) {
        setState(() {
          _imageFile = img;
        });
        _onCheckCanUpdate();
      },
      isLoading: _isLoadingImg,
    );
  }

  Widget get _appBar {
    return RevisitAppbar(
      'Sunting Cerita',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }

  Future<void> _onCheckCanUpdate() async {
    if (_imageFile != null ||
        location != _storyService.currentStoryV2.location ||
        _titleController.text != _storyService.currentStoryV2.title ||
        _descController.text != _storyService.currentStoryV2.text) {
      setState(() {
        canUpdate = true;
      });
      return;
    }

    if (_imageFile == null &&
        location == _storyService.currentStoryV2.location &&
        _titleController.text == _storyService.currentStoryV2.title &&
        _descController.text == _storyService.currentStoryV2.text) {
      setState(() {
        canUpdate = false;
      });
    }
  }
}
