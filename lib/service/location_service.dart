import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandler;
import 'package:get_it/get_it.dart';
import 'package:revisit/service/navigation_service.dart';

class LocationService with ChangeNotifier {
  Position _position;
  Placemark address;
  String _errorLog;
  bool isPositionLoading = true;
  Geolocator geoLocator = Geolocator();

  LocationService() {
    setCurrentLocation();
  }

  Future<HandlingServerLog> setCurrentLocation({
    bool isLastKnown: false,
  }) async {
    isPositionLoading = true;
    notifyListeners();

    /// Check the location permission first
    /// if denied, then return failed.
    var permissionLog = await _grantedPermissionLog;

    if (permissionLog != null) {
      return HandlingServerLog.failed(false, permissionLog);
    }

    try {
      Position pos;

      if (isLastKnown) {
        pos = await Geolocator.getLastKnownPosition();
      } else {
        pos = await await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }

      var addresses = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
        localeIdentifier: 'en',
      );

      if (addresses.isNotEmpty) {
        address = addresses[0];
      }

      _position = pos;
      isPositionLoading = false;
      notifyListeners();

      return HandlingServerLog.success(true, _position);
    } on PlatformException catch (e) {
      _errorLog = e.message;
      isPositionLoading = false;
      notifyListeners();

      return HandlingServerLog.failed(false, _errorLog);
    } catch (e) {
      isPositionLoading = false;
      notifyListeners();

      return HandlingServerLog.failed(false, e.toString());
    }
  }

  Future<String> getCityLocation(double lat, double long) async {
    if (lat == null || long == null) return null;

    if (lat <= 0.0 || long <= 0.0) return null;

    /// Check the location permission first
    /// if denied, then return failed.
    var permissionLog = await _grantedPermissionLog;
    if (permissionLog != null) return permissionLog;

    try {
      var addresses = await placemarkFromCoordinates(
        lat,
        long,
        localeIdentifier: 'en',
      );

      if (addresses.isEmpty) return null;

      var addr = addresses[0];
      if (addr.country.toLowerCase() == "singapore") return "Singapore";

      var isExist = (addr.subAdministrativeArea != null && addr.subAdministrativeArea.isNotEmpty) ||
          (addr.locality != null && addr.locality.isNotEmpty) ||
          (addr.administrativeArea != null && addr.administrativeArea.isNotEmpty);

      if (!isExist) return null;

      return addr.subAdministrativeArea != null && addr.subAdministrativeArea.isNotEmpty
          ? addr.subAdministrativeArea
          : addr.locality != null && addr.locality.isNotEmpty
          ? addr.locality
          : addr.administrativeArea;
    } catch (e, stackTrace) {
      return null;
    }
  }

  Future<Placemark> getLocationInfo(double lat, double long) async {
    if (lat == null || long == null) return null;

    if (lat <= 0.0 || long <= 0.0) return null;

    /// Check the location permission first
    /// if denied, then return failed.
    var permissionLog = await _grantedPermissionLog;
    if (permissionLog != null) return null;

    try {
      var addresses = await placemarkFromCoordinates(
        lat,
        long,
        localeIdentifier: 'en',
      );

      if (addresses.isEmpty) return null;

      var addr = addresses[0];
      return addr;
    } catch (e, stackTrace) {
      return null;
    }
  }


  Future<String> get _grantedPermissionLog async {
    PermissionHandler.PermissionStatus permission;

    try {
      permission = await PermissionHandler.Permission.location.request();
    } catch (e) {
      return null;
    }

    if (permission == PermissionHandler.PermissionStatus.granted) return null;

    var navigatorKey = GetIt.I<NavigationService>().navigatorKey;

    var context = navigatorKey.currentState?.context;
    if (context == null) return 'Permission denied';

    return 'Permission denied';
  }

  Position get position => this._position;

  String get errorLog => this._errorLog;
}