import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/marker_details_cards.dart';
import 'package:trashpick/Widgets/primary_app_bar_widget.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class PickTrashLocation extends StatefulWidget {
  PickTrashLocation(this.currentPosition);

  final Position currentPosition;

  @override
  _PickTrashLocationState createState() => _PickTrashLocationState();
}

class _PickTrashLocationState extends State<PickTrashLocation> {
  Widget _googleMapWidget;
  GoogleMapController _googleMapController;
  String _currentAddress;
  List _trashLocationDetails;
  BitmapDescriptor trashLocationMarkerIcon;
  Map<MarkerId, Marker> trashLocationMarker = <MarkerId, Marker>{};

  @override
  void initState() {
    _googleMapWidget = loadingMap();
    setTrashLocationMarkerIcon();
    super.initState();
  }

  // ---------------------------------- CURRENT USER ---------------------------------- \\

  _getCurrentUserAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          widget.currentPosition.latitude, widget.currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        if (place != null) {
          _currentAddress = "${place.name}, "
              "${place.street}, "
              "${place.locality}, "
              "${place.country}";
        } else {
          _currentAddress = "No Address";
        }
        _googleMapWidget = mapWidget();
      });
    } catch (error) {
      ToastMessages().toastError(error, context);
    }
  }

  // ---------------------------------- COMMON MAP ---------------------------------- \\

  Widget loadingMap() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  setTrashLocationMarkerIcon() async {
    trashLocationMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 5.0), 'assets/icons/icon_bin.png');
  }

  _getTrashLocationAddressFromLatLng(latitude, longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = p[0];
      setState(() {
        if (place != null) {
          _trashLocationDetails = [
            latitude,
            longitude,
            "${place.name}",
            "${place.street}",
            "${place.postalCode}",
            "${place.administrativeArea}",
            "${place.subAdministrativeArea}",
            "${place.thoroughfare}",
            "${place.subThoroughfare}",
            "${place.locality}",
            "${place.subLocality}",
            "${place.country}",
            "${place.isoCountryCode}",
          ];
          /*ToastMessages().toastSuccess("Location Selected: \n"
              "$_trashLocationAddress", context);*/
        } else {
          ToastMessages().toastSuccess("No Address", context);
        }
      });
    } catch (error) {
      ToastMessages().toastError(error.toString(), context);
      print("ERROR=> _getTrashLocationAddressFromLatLng: $error");
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(
            widget.currentPosition.latitude, widget.currentPosition.longitude),
        zoom: 8.5,
      ),
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
      },
      compassEnabled: true,
      tiltGesturesEnabled: false,
      onLongPress: (latLang) {
        _addMarkerLongPressed(latLang);
        print("Long Pressed");
        print("$latLang");
      },
      markers: Set<Marker>.of(trashLocationMarker.values),
    );
  }

  Future _addMarkerLongPressed(LatLng latLang) async {
    setState(() {
      final MarkerId markerId = MarkerId("TrashLocationID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: latLang,
        infoWindow: InfoWindow(
          title: "Trash here",
          snippet: 'This place has trash',
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return MarkerDetailsCard()
                    .showSelectLocationDetails(_trashLocationDetails, context);
              },
            );
          },
        ),
        icon: trashLocationMarkerIcon,
      );

      trashLocationMarker[markerId] = marker;
    });
    _getTrashLocationAddressFromLatLng(latLang.latitude, latLang.longitude);
    GoogleMapController controller = _googleMapController;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 15.0));
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return MarkerDetailsCard()
            .showSelectLocationDetails(_trashLocationDetails, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Select Location",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: IconButton(
              icon: Icon(
                Icons.done_rounded,
                size: 30.0,
              ),
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                ToastMessages().toastSuccess(
                    "Location Selected: \n"
                    "${_trashLocationDetails[0].toString()}, "
                    "${_trashLocationDetails[0].toString()}, "
                    "${_trashLocationDetails[6].toString()}, "
                    "${_trashLocationDetails[5].toString()}",
                    context);
                print(_trashLocationDetails);

                Navigator.pop(context, _trashLocationDetails);
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: mapWidget(),
          )
        ]),
      ),
    );
  }
}
