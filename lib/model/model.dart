import 'package:weatherapp/json/response.dart';


class WeatherModel{
  final String city;
  final int temperature;
  final String description;
  final double rain;
  final String icon;
  final double lat;
  final double long;

  WeatherModel(
      this.city,
      this.temperature,
      this.description,
      this.rain,
      this.icon,
      this.lat, this.long);

  WeatherModel.fromResponse(City response)
      :city = response.name,
      temperature = (response.main.temp - 273.15).ceil(),
      description = response.weather[0].description,
        rain =1,
  lat = response.coord.lat,
  icon = response.weather[0]?.icon,
  long = response.coord.lon;
}