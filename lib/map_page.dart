import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

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

      final placemarks = await placemarkFromCoordinates(
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

  Future<void> _onTap(LatLng latlng) async{
    final placemarks = await placemarkFromCoordinates(
      latlng.latitude,
      latlng.longitude
    );
    final p = placemarks.first;
    setState(() {
      _pickedMarker = Marker(
        markerId: const MarkerId("picked"),
        position: latlng,
        infoWindow: InfoWindow(
          title: p.name?.isNotEmpty == true ? p.name : "Lokasi Dipilih",
          snippet: "${p.street}, ${p.locality}",
        )
      );
    });
    final ctrl = await _ctrl.future;
    await ctrl.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));

    setState(() {
      _pickedAddress = "${p.name}, ${p.street}, ${p.locality}, ${p.country}, ${p.postalCode}";
    });
  }

  void _confirmSelection(){
    showDialog(
        context: context,
        builder:
        (_) => AlertDialog(
          title: const Text("Konfirmasi Alamat"),
          content: Text(_pickedAddress ?? ""),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context,_pickedAddress);
              },
              child: const Text("Pilih"),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_initialcamera == null){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Alamat"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialcamera!,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              rotateGesturesEnabled: true,
              trafficEnabled: true,
              buildingsEnabled: true,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController ctrl){
                _ctrl.complete(ctrl);
              },
              markers: _pickedMarker != null ? {_pickedMarker!} : {},
              onTap: _onTap,
            )
          ],
        ),
      ),
    );
  }
}