import 'dart:ffi';

import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherData, this.error});

  final weatherData;
  final String error;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  var icon;
  double temp;
  var city;
  String message;

  @override
  void initState() {
    super.initState();
    print("initState");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("SchedulerBinding");
      if (widget.weatherData == null) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "LOCATION",
          desc: widget.error,
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("WidgetsBinding");
      // Navigator.of(context).restorablePush(_dialogBuilder);
    });
    updateWeather(widget.weatherData);
  }

  void updateWeather(var weatherData) async {
    setState(() {
      if (weatherData == null) {
        icon = '';
        temp = 0;
        city = '';
        message = widget.error;
      } else {
        icon = weatherModel.getWeatherIcon(weatherData['weather'][0]['id']);
        temp = weatherData['main']['temp'];
        city = weatherData['name'];
        message = weatherModel.getMessage(temp.toInt());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getWeatherData();
                      updateWeather(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      String cityName = await Navigator.push(context,
                          MaterialPageRoute(builder: (_) {
                        return CityScreen();
                      }));
                      print(cityName);
                      if(cityName != null){
                          var weatherData = await weatherModel
                              .getWeatherDataByCity(cityName);
                          if(weatherData['cod'] == 200) {
                            updateWeather(weatherData);
                          } else{
                            Alert(
                              context: context,
                              type: AlertType.error,
                              title: "LOCATION",
                              desc: 'Not found city name',
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  width: 120,
                                )
                              ],
                            ).show();
                          }
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${temp.toStringAsFixed(1)}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      icon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $city',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
