import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/story.dart';
import 'package:revisit/components/image_placeholder.dart';

class StoryExploreCard extends StatelessWidget {
  final Story story;
  final Function onPress;

  StoryExploreCard({
    @required this.story,
    this.onPress,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RevisitImgPlaceHolder(
              imgSrc: story.picture,
              fit: BoxFit.cover,
              height: 190,
              emptyHeight: 190,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                story.title,
                style: TextStyle(
                  fontSize: Constant.MINIMUM_FONT_SIZE_SM,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: Text(
                story.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: Constant.MINIMUM_FONT_SIZE,
                  color: Constant.GRAY_TEXT,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: Text(
                story.createdAt.toString(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: Constant.MINIMUM_FONT_SIZE,
                  color: Constant.GRAY_TEXT,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
