

import 'package:revisit/models/report.dart';

class ReportUtils {
  bool checkIfReported(List<Report> reports, String userId) {
    bool isReported = false;
    if (reports == null) {
      return isReported;
    }

    if (reports != null) {
      if (reports.isEmpty) {
        return isReported;
      }

      var listOfList = reports.map((e) => e.userId).toList();
      if (listOfList.contains(userId)) {
        isReported = true;
        return isReported;
      }
      if (!listOfList.contains(userId)) {
        return isReported;
      }
    }

    return isReported;
  }
}
