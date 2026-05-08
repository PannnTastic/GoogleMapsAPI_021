import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'map_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? alamatDipilih;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Pilih Alamat"),
                            IconButton(
                                onPressed: ()async {
                                  final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MapPage(),
                                  ),
                                  );
                                  if(result != null){
                                    setState(() {
                                      alamatDipilih = result;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.map,color: Colors.blue)
                            )
                          ],
                        ),
                        alamatDipilih == null
                        ? const Text("Tidak ada alamat yang dipilih")
                        : Text("Alamat yang dipilih: $alamatDipilih"),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

}