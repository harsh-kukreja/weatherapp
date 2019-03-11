import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/json/response.dart';
import 'package:weatherapp/model/model.dart';
import 'package:weatherapp/const.dart';

class WeatherRepo{
  final http.Client client;

  WeatherRepo({this.client});

  int cnt = 50;
  void addCities(int count){
    cnt = count;
  }

  Future<List<WeatherModel>> updateWeather(Position result) async{
    String url;

    if(result != null){
      print("Inside if of weather modelr");
      url = "https://api.openweathermap.org/data/2.5/find?lat=${result.latitude}&lon=${result.longitude}&cnt=$cnt&appid=$API_KEY";

    }else{
      print("Inside else of weather model");
      url = "https://api.openweathermap.org/data/2.5/find?lat=43&lon=-79&cnt=$cnt&appid=$API_KEY";
    }

    final response = await client.get(url);

    List<WeatherModel> req = BaseResponse
        .fromJson(json.decode(response.body) as Map<String, dynamic>)
        .cities
        .map((city) => WeatherModel.fromResponse(city) )
        .toList();

    return req;
  }

  Future<Position> updateLocation(dynamic item) {
    print("Inside Weather updateLocation");
    Future<Position> location = Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return location;
  }

  Future<bool> getGps() async{
    print("Inside Weather GetGps");
    final GeolocationStatus result = await Geolocator().checkGeolocationPermissionStatus();
    if(result == GeolocationStatus.granted)
      return true;
    else
      return false;
  }


}