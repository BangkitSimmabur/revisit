import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:revisit/constant.dart';


class RevisitSpinner extends StatelessWidget {
  final double spinnerSize;

  RevisitSpinner({this.spinnerSize = 50});

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: spinnerSize,
      width: spinnerSize,
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : SpinKitFadingCircle(
        color: Constant.blue01,
      ),
    ),
  );
}
