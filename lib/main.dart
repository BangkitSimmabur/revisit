import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:revisit/components/button_full.dart';
import 'package:revisit/components/inputCommon.dart';
import 'package:revisit/components/revisit_spinner.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/type.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  Geolocator geoLocator = Geolocator();

  var _markers = <String, Marker>{};
  LatLng _currentPosition = LatLng(3.595196, 98.672226);
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
  }

  @override
  Widget build(BuildContext context) {

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
      'INPUT LOKASI',
      isIntl: true,
      buttonColor: Constant.blue01,
      onClick: () {
        print(_pc.isPanelClosed());
        print(_pc.isPanelOpen());
        print(_pc.isPanelShown());
        print('pcppooooo');      },
      height: 56,
      borderRadius: 0,
      labelSize: Constant.MINIMUM_FONT_SIZE + 2,
    );
  }

  Widget get _addressElement {
    return Expanded(
      child: Text(
        isAddressEmpty() ? 'Alamat belum dimasukkan' : _getAddress(),
        maxLines: 3,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: Constant.MINIMUM_FONT_SIZE + 2,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  bool isAddressEmpty() {
    if ((alamat == null || alamat == '') &&
        (provinsi == null || provinsi == '') &&
        (kota == null || kota == '') &&
        (kodePos == null || kodePos == '')) {
      return true;
    } else {
      return false;
    }
  }

  String _getAddress() {
    return "${alamat != null || alamat != '' ? '$alamat ' : ''}"
        "${provinsi != null || provinsi != '' ? '$provinsi ' : ''}"
        "${kota != null || kota != '' ? '$kota ' : ''}"
        "${kodePos != null || kodePos != '' ? '$kodePos ' : ''}";
  }

  Widget get mapElement {
    var _paddingBottomCentral = 63.0;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
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
    // if (_isLoading) return RevisitSpinner();

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

    print('esd');
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
      });
    } catch (e) {
      print('error');
    }

    return setState(() => _isLoading = false);
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
