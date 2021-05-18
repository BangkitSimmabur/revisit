import 'package:flutter/material.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/article.dart';
import 'package:revisit/components/image_placeholder.dart';

class ArticleExploreCard extends StatelessWidget {
  final Article article;
  final Function onPress;

  ArticleExploreCard({
    @required this.article,
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
              imgSrc: article.picture,
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
                article.title,
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
                article.text,
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
                article.createdAt.toString(),
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
