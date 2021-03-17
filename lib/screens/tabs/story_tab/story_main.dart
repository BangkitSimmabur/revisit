import 'package:flutter/material.dart';
import 'package:revisit/Screens/tabs/story_tab/create_story.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/platform/platform_main.dart';

class StoryMain extends StatefulWidget {
  @override
  _StoryMainState createState() => _StoryMainState();
}

class _StoryMainState extends State<StoryMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Container(
        child: Text("Story"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toCreateStory();
        },
        child: Icon(Icons.add),
        backgroundColor: Constant.blue01,
      ),
    );
  }

  void _toCreateStory() {
    MainPlatform.transitionToPage(context, CreateStory());
  }

}
