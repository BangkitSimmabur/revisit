import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/location_service.dart';
import 'package:revisit/type.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RevisitInputMap extends StatefulWidget {
  RevisitInputMap({
    this.initLocationData,
  });

  final LocationData initLocationData;

  @override
  _RevisitInputMapState createState() => _RevisitInputMapState();
}

class _RevisitInputMapState extends State<RevisitInputMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  Geolocator geoLocator = Geolocator();
  LocationService _locationService;

  var _markers = <String, Marker>{};
  LatLng _currentPosition;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  CameraPosition _currentCameraPosition;
  bool _isLoading = true;
  LatLng _currentLatLng;
  String kota = '';
  String alamat = '';
  String kodePos = '';
  String provinsi = '';
  GoogleMapController mapController;
  PanelController _pc = PanelController();
  LocationData _locationData;

  Future _grantedPermissionLog() async {
    PermissionHandler.PermissionStatus permission;

    try {
      permission = await PermissionHandler.Permission.location.request();
    } catch (e) {
      return null;
    }

    if (permission == PermissionHandler.PermissionStatus.granted) return null;

    /// If not granted
    /// then return the log.
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _onInitDataState);

    super.initState();
  }

  Future _onInitDataState() async {
    await _grantedPermissionLog();
    if (widget.initLocationData.longitude != null &&
        widget.initLocationData.latitude != null) {
      setState(() {
        _currentPosition = LatLng(
          widget.initLocationData.latitude,
          widget.initLocationData.longitude,
        );
        _currentLatLng = _currentPosition;
        _fullAddressController.text = widget.initLocationData.address;
        _isLoading = false;
      });
      return;
    }
    _onCheckMyLoc();
  }

  @override
  Widget build(BuildContext context) {
    _locationService = Provider.of<LocationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Input Lokasi'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 4 / 6,
            minHeight: 180,
            controller: _pc,
            backdropTapClosesPanel: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            body: mapElement,
            panel: _formElement,
            parallaxEnabled: true,
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _slidingPanelScroll(() => _pc.open()),
                  Container(
                    height: Constant.MINIMUM_SPACING,
                  ),
                  _addressElement,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _saveLocationElement,
          ),
        ],
      ),
    );
  }

  Widget get _saveLocationElement {
    // if (!_canSave) return Container();

    return RevisitButtonFull(
      'SIMPAN LOKASI',
      buttonColor: Constant.blue01,
      onClick: () {
        _onSaveLocation();
      },
      height: 56,
      borderRadius: 0,
      labelSize: Constant.MINIMUM_FONT_SIZE + 2,
    );
  }

  Widget get _addressElement {

    if (_isLoading) return RevisitSpinner();

    return RevisitInputCommon(
      "Lokasi",
      labelMinLine: 1,
      labelMaxLine: 3,
      isDense: true,
      inputController: _fullAddressController,
      noLabel: true,
      hintText: "Lokasi",
      onChange: null,
    );
    // return Expanded(
    //   child: Text(
    //     isAddressEmpty() ? 'Alamat belum dimasukkan' : _getAddress(),
    //     maxLines: 3,
    //     textAlign: TextAlign.center,
    //     overflow: TextOverflow.ellipsis,
    //     style: TextStyle(
    //       fontSize: Constant.MINIMUM_FONT_SIZE + 2,
    //       fontWeight: FontWeight.w500,
    //       color: Colors.grey,
    //     ),
    //   ),
    // );
  }

  String _getAddress() {
    return "${alamat != null || alamat != '' ? '$alamat ' : ''}"
        "${provinsi != null || provinsi != '' ? '$provinsi ' : ''}"
        "${kota != null || kota != '' ? '$kota ' : ''}"
        "${kodePos != null || kodePos != '' ? '$kodePos ' : ''}";
  }

  Widget get mapElement {
    var _paddingBottomCentral = 63.0;
    var initCamPos = widget.initLocationData != null
        ? LatLng(
            widget.initLocationData?.latitude ??
                Constant.INIT_LOCATION.latitude,
            widget.initLocationData?.longitude ??
                Constant.INIT_LOCATION.longitude)
        : LatLng(
            _locationService.position?.latitude ??
                Constant.INIT_LOCATION.latitude,
            _locationService.position?.longitude ??
                Constant.INIT_LOCATION.longitude,
          );

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initCamPos,
            zoom: 14.0,
          ),
          markers: Set<Marker>.of(_markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            setState(() => mapController = controller);

            _controller.complete(controller);
          },
          onTap: _onTapCoord,
          onCameraIdle: _onCameraIdle,
          onCameraMove: (camPos) {
            setState(() {
              _currentCameraPosition = camPos;
            });
          },
        ),
        Align(
          alignment: FractionalOffset.center,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: _paddingBottomCentral,
            ),
            child: _centralElement,
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 240,
            ),
            child: _myLocationButton,
          ),
        ),
      ],
    );
  }

  Widget get _formElement {
    if (_isLoading) return RevisitSpinner();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _slidingPanelScroll(() {
          _pc.close();
          print('closing');
        }),
        Expanded(
          child: Form(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    Constant.DEFAULT_PADDING_VIEW,
                top: Constant.DEFAULT_PADDING_VIEW,
                left: Constant.DEFAULT_PADDING_VIEW,
                right: Constant.DEFAULT_PADDING_VIEW,
              ),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: Constant.MINIMUM_SPACING,
                    ),
                    _textFormComponent(
                      'Provinsi',
                      true,
                      _provinsiController,
                      (str) {
                        setState(() {
                          provinsi = str;
                          _fullAddressController.text = _getAddress();
                        });
                      },
                      provinsi == '' || provinsi == null,
                    ),
                    Container(
                      height: Constant.MINIMUM_SPACING,
                    ),
                    _textFormComponent(
                      'Kota',
                      true,
                      _kotaController,
                      (str) {
                        setState(() {
                          kota = str;
                          _fullAddressController.text = _getAddress();
                        });
                      },
                      kota == '' || kota == null,
                    ),
                    Container(
                      height: Constant.MINIMUM_SPACING,
                    ),
                    _textFormComponent(
                      'Alamat',
                      true,
                      _alamatController,
                      (str) {
                        setState(() {
                          alamat = str;
                          _fullAddressController.text = _getAddress();
                        });
                      },
                      alamat == '' || alamat == null,
                    ),
                    Container(
                      height: Constant.MINIMUM_SPACING,
                    ),
                    _textFormComponent(
                      'Pos',
                      false,
                      _posController,
                      (str) {
                        setState(() {
                          kodePos = str;
                          _fullAddressController.text = _getAddress();
                        });
                      },
                      kodePos == '' || kodePos == null,
                    ),
                    Container(
                      height: Constant.MINIMUM_SPACING,
                    ),
                  ],
                ),
                Container(
                  height: 56,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFormComponent(
    final String _formTitle,
    final bool needWarning,
    final TextEditingController _formController,
    final OnChangeStr _onChangeStr,
    final bool _isEmpty,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  _formTitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Constant.MINIMUM_FONT_SIZE - 3.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        RevisitInputCommon(
          _formTitle,
          hintText: _formTitle,
          labelMinLine: 1,
          labelMaxLine: 3,
          isDense: true,
          inputController: _formController,
          noLabel: true,
          onChange: _onChangeStr,
        ),
        needWarning
            ? _isEmpty
                ? _warningText('$_formTitle tidak boleh kosong')
                : Container()
            : Container(),
        Container(
          height: Constant.MINIMUM_SPACING,
        ),
      ],
    );
  }

  Widget _slidingPanelScroll(Function onTap) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            Container(
              height: Constant.MINIMUM_SPACING_XLG + 6,
              width: double.maxFinite,
              color: Colors.transparent,
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Constant.MINIMUM_SPACING_XLG / 2,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constant.blue01,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 6,
                  width: MediaQuery.of(context).size.width / 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _myLocationButton {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      opacity: 1.0,
      child: Material(
        color: Colors.transparent,
        child: RawMaterialButton(
          onPressed: _onCheckMyLoc,
          child: ClipOval(
            child: Image.asset(
              'assets/located_main.png',
              height: 48,
            ),
          ),
          shape: CircleBorder(),
          elevation: 2,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _onCheckMyLoc() async {
    setState(() => _isLoading = true);

    await setCurrentLocation();

    final GoogleMapController controller = await _controller.future;

    setState(() => _isLoading = false);

    return controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 14,
        ),
      ),
    );
  }

  Future setCurrentLocation() async {
    /// Check the location permission first
    /// if denied, then return failed
    Position pos;
    pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print(pos);
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  Widget get _centralElement {
    return Material(
      color: Colors.transparent,
      child: Image.asset(
        'assets/located_2_main.png',
        height: 65.0,
      ),
    );
  }

  Future<void> _onTapCoord(LatLng latLng) async {
    return _changeCameraPosition(
      Position(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      ),
    );
  }

  Future _changeCameraPosition(Position pos) async {
    final GoogleMapController controller = await _controller.future;
    final cameraPosition = CameraPosition(
      zoom: 14.0,
      target: LatLng(pos.latitude, pos.longitude),
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> _onCameraIdle() async {
    if (_currentCameraPosition == null) return;

    var latLng = _currentCameraPosition.target;

    setState(() {
      _currentLatLng = latLng;
    });
    print('asd');

    /// Search the location based on latitude and longitude.
    try {
      print('trying');
      List<Placemark> placeMark = await placemarkFromCoordinates(
        _currentLatLng.latitude,
        _currentLatLng.longitude,
        localeIdentifier: 'id',
      );

      Placemark a = placeMark[0];

      print('asd');
      print(a);
      setState(() {
        kodePos = a.postalCode ?? '';
        kota = a.subAdministrativeArea ?? '';
        provinsi = a.administrativeArea ?? '';
        alamat = a.street ?? '';
        _alamatController.text = a.street ?? '';
        _provinsiController.text = a.administrativeArea ?? '';
        _posController.text = a.postalCode ?? '';
        _kotaController.text = a.subAdministrativeArea ?? '';
        _fullAddressController.text = _getAddress();
      });
    } catch (e) {
      print('error');
    }

    return setState(() => _isLoading = false);
  }

  Future<void> _onSaveLocation() async {
    var isAccept = await MainPlatform.showConfirmationAlert(
      context,
      Text(
        'Simpan lokasi',
      ),
      Text(
        'Anda yakin?',
      ),
    );

    if (isAccept != ConfirmAction.ACCEPT) {
      return MainPlatform.backTransitionPage(context);
    }

    if (_fullAddressController.text.isNotEmpty) {
      setState(() {
        _locationData = new LocationData(
          _currentLatLng.latitude,
          _currentLatLng.longitude,
          _fullAddressController.text,
        );
        // _locationData.latitude = _currentLatLng.latitude;
        // _locationData.longitude = _currentLatLng.longitude;
        // _locationData.address = _getAddress();
      });
      return MainPlatform.backTransitionPage(
        context,
        value: _locationData,
      );
    } else {
      return MainPlatform.backTransitionPage(
        context,
        value: null,
      );
    }
  }

  Widget _warningText(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.red,
                fontSize: Constant.MINIMUM_FONT_SIZE - 7,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
