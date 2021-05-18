import 'dart:io' show File, Platform;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';

class RevisitInputImageCommon extends StatefulWidget {
  final String src;
  final SavedImageProfile onSavedImage;
  final bool isLoading;

  RevisitInputImageCommon(
    this.src, {
    this.onSavedImage,
    this.isLoading = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _RevisitInputImageCommonState();
  }
}

class _RevisitInputImageCommonState extends State<RevisitInputImageCommon> {
  File galleryFile;
  double width;
  double heightBtn;
  Widget imageSelected;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.width = MediaQuery.of(context).size.width * 0.8;
    this.heightBtn = this.width / 5;

    if (this.widget.src != null && this.galleryFile == null) {
      imageSelected = Image.network(
        this.widget.src,
        fit: BoxFit.cover,
        width: width,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      );
    } else if (this.galleryFile != null) {
      imageSelected = Image.file(
        this.galleryFile,
        fit: BoxFit.cover,
        width: width,
      );
    } else {
      imageSelected = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'assets/images/placeholder_image.png',
          fit: BoxFit.cover,
          width: width - 32,
        ),
      );
    }

    return Container(
      key: widget.key ?? null,
      padding: EdgeInsets.all(Constant.MINIMUM_PADDING / 2),
      child: Center(
          child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constant.GRAY02,
              ),
              child: this.widget.isLoading
                  ? _imageSelectedLoading
                  : _imageSelectedPlaceholder),
          Positioned(
            right: -this.heightBtn / 3,
            bottom: -this.heightBtn / 5,
            child: Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme(
                    height: this.heightBtn,
                    disabledColor: Colors.grey.shade400,
                    child: RaisedButton(
                      onPressed: !this.widget.isLoading ? _selectImage : null,
                      child:
                          Icon(Icons.camera_alt, size: this.heightBtn - 15.0),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Future<void> _imageSelectorGallery(ImageSource source) async {
    if (source == null) return;

    PickedFile pickedImageFile = await _picker.getImage(source: source);

    if (pickedImageFile == null) {
      final LostData response = await _picker.getLostData();
      if (response == null) {
        return;
      }
      if (response.file != null) {
        pickedImageFile = response.file;
      }
    }

    File pickedImage = File(pickedImageFile.path);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: source == ImageSource.camera ? "Kamera" : "Galeri",
          toolbarColor: Constant.BLUE03,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          statusBarColor: Constant.BLUE03,
          activeControlsWidgetColor: Constant.BLUE03,
        ),
        iosUiSettings: IOSUiSettings(
          title: source == ImageSource.camera ? "Kamera" : "Galeri",
          aspectRatioLockEnabled: true,
          doneButtonTitle: "Selesai",
          cancelButtonTitle: "Batalkan",
          minimumAspectRatio: 1,
        ));
    if (croppedFile != null) {
      setState(() {
        this.galleryFile = croppedFile;
      });
      if (widget.onSavedImage != null) {
        widget.onSavedImage(croppedFile);
      }
    } else {
      setState(() {
        this.galleryFile = null;
      });
      if (widget.onSavedImage != null) {
        widget.onSavedImage(null);
      }
    }
  }

  Widget get _imageSelectedLoading {
    return Container(
        width: width,
        child: SpinKitThreeBounce(
          color: Constant.GRAY_TEXT,
          size: Constant.MINIMUM_FONT_SIZE,
        ));
  }

  Widget get _imageSelectedPlaceholder {
    return Stack(
      children: <Widget>[
        imageSelected,
        new Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  splashColor: Colors.black12,
                  onTap: !this.widget.isLoading ? _selectImage : null,
                ))),
      ],
    );
  }

  void _selectImage() {
    MainPlatform.asyncShowAlertSelectImage(context).then((imgSource) {
      this._imageSelectorGallery(imgSource);
    });
  }
}

typedef void SavedImageProfile(File file);
