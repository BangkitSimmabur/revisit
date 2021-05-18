import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:revisit/models/location.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMapElement extends StatelessWidget {
  final LocationData locationData;

  DetailMapElement(
    this.locationData,
  );

  final _markers = <String, Marker>{};

  @override
  Widget build(BuildContext context) {
    var _paddingBottomCentral = 63.0;

    return Container(
      height: 200,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(locationData.latitude,locationData.longitude),
              zoom: 14.0,
            ),
            scrollGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: false,
            onTap: (loc) {
              _onMapPressed(loc);
            },
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
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
        ],
      ),
    );
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

  Future<void> _onMapPressed(LatLng loc) async {
    if (await canLaunch(
        'http://maps.google.com/?q={${loc.latitude},${loc.longitude}')) {
      await launch('http://maps.google.com/?q=1.143532,104.002419');
    } else {
      throw 'Tidak dapat membuka peta lokasi';
    }
  }
}
