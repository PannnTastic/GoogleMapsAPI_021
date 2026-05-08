import 'package:flutter/material.dart';
import 'package:gmaps_flutter/home_page.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform implementation = GoogleMapsFlutterPlatform.instance;
  if(implementation is GoogleMapsFlutterAndroid){
    implementation.useAndroidViewSurface =true;
  }
  runApp(const MyApp());
}

void initializeMapRenderer() async {
  final GoogleMapsFlutterPlatform implementation = GoogleMapsFlutterPlatform.instance;
  if(implementation is GoogleMapsFlutterAndroid){
    await implementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Flutte Google Maps",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
