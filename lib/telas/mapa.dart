import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {

  final String? idViagem;

  const Mapa({super.key, this.idViagem });

  @override
  State<Mapa> createState() => _Mapa();
}

class _Mapa extends State<Mapa> {

  final Set<Marker> marcadores = {};

  late StreamSubscription<Position> _positionStream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void _exibirMarcador(LatLng latLng) {

    final latitude = latLng.latitude;

    final longitude = latLng.longitude;

    placemarkFromCoordinates(latitude, longitude).then((listaEndereco){
      
      if(listaEndereco.isNotEmpty){

        Placemark endereco = listaEndereco[0];
        String rua = endereco.thoroughfare!;

        final Marker marcador = Marker(
          markerId: MarkerId("marcador-$latitude-$longitude"),
          position: latLng,
          infoWindow: InfoWindow(
            title: rua
          )
        );

        final data = {
          "titulo": rua,
          "latitude": latitude,
          "longitude": longitude
        };

        setState(() {
          marcadores.add(marcador);

          _firestore.collection("viagens")
            .add(data);
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

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 60)
      )
    ).listen((position) {
      
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18
        );
        _movimentarCamera();
      });
  }

  _addMarcadorMapa(){

    if(widget.idViagem != null){
      _firestore.collection("viagens")
        .doc(widget.idViagem)
        .get()
        .then((docmento){
          final viagem = docmento.data()!;

          final latitude = viagem["latitude"];
          final longitude = viagem["longitude"];
          final titulo = viagem["titulo"];

          final Marker marcador = Marker(
            markerId: MarkerId("marcador-$latitude-$longitude"),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: titulo
            )
          );

          setState(() {
            marcadores.add(marcador);

            _cameraPosition =  CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 18
            );

            _movimentarCamera();
          });
        });
    }else {
      _addListenerLocalizacao();
    }
  }

  @override
  void initState() {
    super.initState();
    _addMarcadorMapa();
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   _positionStream.cancel();
  // }
}