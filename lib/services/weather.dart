import 'package:clima/screens/loading_screen.dart';

import 'networking.dart';

class WeatherModel {

  Future getWeatherData() async{
    await location.getCurrentLocation().catchError((e){
      return Future.error(e);
    });
    NetworkHelper networkHelper = NetworkHelper(
        'http://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var jsonData = await networkHelper.getData();
    return jsonData;
  }

  Future getWeatherDataByCity(String cityName) async{
    NetworkHelper networkHelper = NetworkHelper('http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    var jsonData = await networkHelper.getData();
    return jsonData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
