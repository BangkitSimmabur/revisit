import 'package:revisit/models/article.dart';
import 'package:revisit/models/like.dart';

class ArticleUtils {
  Article storyV2ToStory(ArticleV2 articleV2) {
    List<String> comments = <String>[];
    var commentList = articleV2.comments;
    if (commentList == null) {
      comments = null;
    }

    if (commentList != null) {
      if (commentList.isEmpty) {
        comments = null;
      }
      if (commentList.isNotEmpty) {
        var listOfList = commentList.map((e) => e.id).toList();
        comments = listOfList;
      }
    }

    Article article = new Article(
        articleV2.id,
        articleV2.title,
        articleV2.text,
        articleV2.user,
        articleV2.location,
        articleV2.createdAt,
        articleV2.updateAt,
        comments,
        articleV2.published,
        articleV2.picture,
        articleV2.likes,
        articleV2.reports);

    return article;
  }
}
