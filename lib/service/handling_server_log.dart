class HandlingServerLog {
  bool _success;
  dynamic _data;
  String _message;

  bool get success => _success;

  dynamic get data => _data;

  String get message => _message;

  HandlingServerLog.success(this._success, this._data);

  HandlingServerLog.failed(this._success, this._message);

  set message(String value) {
    _message = value;
  }

  set data(dynamic value) {
    _data = value;
  }

  set success(bool value) {
    _success = value;
  }
}