import 'package:flutter/material.dart';
import 'package:revisit/models/picture.dart';

class RevisitImgPlaceHolder extends StatefulWidget {
  final Picture imgSrc;
  final BoxFit fit;
  final double emptyHeight;
  final double height;

  RevisitImgPlaceHolder({
    this.imgSrc,
    this.fit,
    this.height,
    this.emptyHeight,
  });

  @override
  _RevisitImgPlaceHolderState createState() => _RevisitImgPlaceHolderState();
}

class _RevisitImgPlaceHolderState extends State<RevisitImgPlaceHolder> {
  @override
  Widget build(BuildContext context) {
    return imagePlaceHolder;
  }

  Widget get imagePlaceHolder {
    if (widget.imgSrc == null) {
      return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Image.asset(
          'assets/images/placeholder_image.png',
          fit: BoxFit.cover,
          height: widget.emptyHeight,
        ),
      );
    }

    if (widget.imgSrc != null) {
      if (widget.imgSrc.fullImage == null) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Image.asset(
            'assets/images/placeholder_image.png',
            // fit: BoxFit.cover,
            height: widget.height,
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.network(
          widget.imgSrc.fullImage,
          fit: BoxFit.cover,
          height: widget.height,
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
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Image.asset(
        'assets/images/placeholder_image.png',
        fit: BoxFit.cover,
        height: widget.emptyHeight,
      ),
    );
  }
}
