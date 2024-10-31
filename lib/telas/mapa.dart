import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {

  const Mapa({super.key});

  @override
  State<Mapa> createState() => _Mapa();
}

class _Mapa extends State<Mapa> {

  final Set<Marker> marcadores = {};

  int contador = 0;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {

    _controller.complete( controller );
  }

  void _exibirMarcador(LatLng latLng) {

    final Marker marcador = Marker(
      markerId: MarkerId((contador++).toString()),
      position: latLng,
      infoWindow: const InfoWindow(
        title: "Marcador"
      )
    );

    setState(() {
      marcadores.add(marcador);
    });
  }

  @override
  Widget build (BuildContext context ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa")
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
          target: LatLng(-23.708762633339163, -46.62731574801392),
          zoom: 18
        ),
        onMapCreated: _onMapCreated,
        onLongPress: _exibirMarcador,
        markers: marcadores,
      ),
    );
  }
}