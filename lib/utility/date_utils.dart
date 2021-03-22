class DateUtils{
  static dynamic convertDateAndIsoString(dynamic dateIso) {
    if (dateIso == null) return null;

    switch (dateIso.runtimeType) {
      case DateTime:
        var dateRaw = dateIso as DateTime;
        return dateRaw.toIso8601String();
      case String:
        try {
          var dateRaw = dateIso as String;
          return DateTime.parse(dateRaw).toLocal();
        } catch (e) {
          return null;
        }
        break;
      default:
        return null;
    }
  }
}