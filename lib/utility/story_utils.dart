import 'package:revisit/models/like.dart';
import 'package:revisit/models/story.dart';

class StoryUtils {
  Story storyV2ToStory(StoryV2 storyV2) {
    List<String> comments = <String>[];
    var commentList = storyV2.comments;
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

    Story story = new Story(
        storyV2.id,
        storyV2.title,
        storyV2.text,
        storyV2.user,
        storyV2.location,
        storyV2.createdAt,
        storyV2.updateAt,
        comments,
        storyV2.published,
        storyV2.picture,
        storyV2.likes,
        storyV2.reports);

    return story;
  }
}
