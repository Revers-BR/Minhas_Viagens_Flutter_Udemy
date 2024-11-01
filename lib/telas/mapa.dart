import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {

  const Mapa({super.key});

  @override
  State<Mapa> createState() => _Mapa();
}

class _Mapa extends State<Mapa> {

  final Set<Marker> marcadores = {};

  CameraPosition _cameraPosition =  const CameraPosition(
    target: LatLng(
      -23.708762633339163, -46.62731574801392
    ),
    zoom: 18
  );

  int contador = 0;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  void _onMapCreated(GoogleMapController controller) {

    _controller.complete( controller );
  }

  void _exibirMarcador(LatLng latLng) async {

    final latitude = latLng.latitude;

    final longitude = latLng.longitude;

    placemarkFromCoordinates(latitude, longitude).then((listaEndereco){
      
      if(listaEndereco.isNotEmpty){

        Placemark endereco = listaEndereco[0];
        String rua = endereco.thoroughfare!;

        final Marker marcador = Marker(
          markerId: MarkerId((contador++).toString()),
          position: latLng,
          infoWindow: InfoWindow(
            title: rua
          )
        );

        setState(() {
          marcadores.add(marcador);
        });
      }
    });
  }

  _movimentarCamera() async {

    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      _cameraPosition
    ));
  }

  _addListenerLocalizacao(){

    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high
    ).listen((position) {
      
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18
        );
        _movimentarCamera();
      });
    
  }

  @override
  void initState() {
    super.initState();
    _addListenerLocalizacao();
  }

  @override
  Widget build (BuildContext context ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa")
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _cameraPosition,
        onMapCreated: _onMapCreated,
        onLongPress: _exibirMarcador,
        myLocationEnabled: true,
        markers: marcadores,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.future.then((controller) => controller.dispose());
  }
}