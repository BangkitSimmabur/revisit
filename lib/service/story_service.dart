import 'dart:io';

import 'package:http/http.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/models/story.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/network_service.dart';

class StoryService extends NetworkService {
  StoryService(ConstantService constantService) : super(constantService);

  var storyList = <Story>[];
  Story currentStory;

  Future<HandlingServerLog> createStory({
    String title,
    String text,
    File photo,
    ItemAction action,
    String phoneNumber,
    LocationData locationData,
  }) async {
    HandlingServerLog serverLog;
    if (action == ItemAction.create) {
      Map reqBody = {
        "title": "The title for your story",
        "text": "This for the body your story",
        "location": locationData,
      };
      HandlingServerLog serverLog = await doHttpPost('story/', reqBody);

      if (!serverLog.success) {
        return serverLog;
      }

      currentStory = storyFromJson(serverLog.data);

      // var storyCreated = serverLog?.data;
      if (photo != null) {
        var handlingLog = await doHttpPutUpload(
          'story/upload/banner/${currentStory.id}',
          photo
        );
        
        if (!handlingLog.success) {
          handlingLog = await doHttpDelete('story/delete/${currentStory.id}');

          currentStory = null;
          return new HandlingServerLog.failed(false, "failed");
        }
      }
      currentStory = null;

      return serverLog;
    } else if (action == ItemAction.update && currentStory.id != null) {

      if (!serverLog.success) {
        return serverLog;
      }
    }

    return serverLog;
  }
}
