import 'package:flutter/material.dart';
import 'package:revisit/components/common_appbar.dart';
import 'package:revisit/constant.dart';

class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  @override
  Widget build(BuildContext context) {
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
            Expanded(child: Center(
              child: _formElement,
            ))
          ],
        )
      ],
    )  ;
  }

  Widget get _formElement {
    return ListView(
      padding: EdgeInsets.all(Constant.DEFAULT_PADDING_VIEW),
      children: [
        Container(
          height: Constant.MINIMUM_SPACING,
        )
      ],
    );
  }
  
  Widget get _appBar {
    return RevisitAppbar(
      'Registrasi',
      bgColor: Constant.blue01,
      trailingColor: Colors.white,
    );
  }
}
