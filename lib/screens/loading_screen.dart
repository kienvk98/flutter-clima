import 'dart:convert';

import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const apiKey = 'fdecb32def36425f28dc5bf3408fb6e5';

Location location = Location();

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getLocation() async {
    var error;
    var weatherData = await WeatherModel().getWeatherData().catchError((e) {
      error = e;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return LocationScreen(
          weatherData: weatherData,
          error: error,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
        ),
      ),
    );
  }
}
