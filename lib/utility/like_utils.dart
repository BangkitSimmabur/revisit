import 'package:revisit/models/like.dart';

class LikeUtils {
  bool checkIfLiked(List<Like> likes, String userId) {
    bool isLiked = false;
    if (likes == null) {
      return isLiked;
    }

    if (likes != null) {
      if (likes.isEmpty) {
        return isLiked;
      }

      var listOfList = likes.map((e) => e.userId).toList();
      if (listOfList.contains(userId)) {
        isLiked = true;
        return isLiked;
      }
      if (!listOfList.contains(userId)) {
        return isLiked;
      }
    }

    return isLiked;
  }
}
