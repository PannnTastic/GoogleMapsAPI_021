import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key})

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  String? _currentAddress;
  CameraPosition? _initialcamera;
  Position? _currentPosition;

  @override
  void initState(){
    super.initState();
    _setupLocation();
  }

  Future<void> _setupLocation()async{
    try{
      final pos = await getPermission();
      _currentPosition = pos;
      _initialcamera = CameraPosition(
        target: LatLng(
        pos.latitude,
        pos.longitude),
        zoom: 16,
      );

      final placemarks = await.placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude
      );

      final p = placemarks.first;
      _currentAddress = "${p.name}, ${p.locality}, ${p.country}";

      setState(() {

      });
    }catch(e){
      _initialcamera = const CameraPosition(target: LatLng(0, 0),zoom: 2);
      setState(() {

      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<Position> getPermission() async{
    if(!await Geolocator.isLocationServiceEnabled()){
      throw "Location service belum aktif";
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied){
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied){
        throw "Izin Lokasi Ditolak";
      }
    }

    return Geolocator.getCurrentPosition();
  }

}