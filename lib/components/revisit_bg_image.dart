import "package:flutter/material.dart";

class RevisitBackgroundImage extends StatelessWidget {
  final String src;

  RevisitBackgroundImage({
    @required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      this.src,
      fit: BoxFit.cover,
    );
  }
}
