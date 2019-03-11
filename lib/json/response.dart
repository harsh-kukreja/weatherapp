import 'package:json_annotation/json_annotation.dart';


part 'response.g.dart';


@JsonSerializable()
class BaseResponse extends Object{

  final String message;
  final String cod;
  final int count;
  @JsonKey(name: "list")
  final List<City> cities;

  BaseResponse(
      this.message,
      this.cod,
      this.count,
      this.cities,

      );

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);

}

@JsonSerializable()
class City extends Object {

  final int id;
  final String name;
  final Coord coord;
  final Main main;
  final int dt;
  @JsonKey(nullable: true)
  final Wind wind;
  //As in the json file rain and wind can be null
  @JsonKey(nullable: true)
  final Rain rain;
  final Clouds clouds;
  final List<Weather> weather;



  City(
      this.id,
      this.name,
      this.coord,
      this.main,
      this.dt,
      this.wind,
      this.rain,
      this.clouds,
      this.weather);

  factory City.fromJson(Map<String, dynamic> json)=> _$CityFromJson(json);

}

@JsonSerializable()
class Coord{

  final double lat;
  final double lon;

  factory Coord.fromJson(Map<String, dynamic> json)=> _$CoordFromJson(json);

  Coord(this.lat,this.lon);
}

@JsonSerializable()
class Main extends Object{

  final double temp;
  final double pressure;
  final int humidity;
  @JsonKey(name: "temp_max")
  final double tempMax;
  @JsonKey(name: "temp_min")
  final double tempMin;


  Main(this.temp, this.pressure, this.humidity, this.tempMax, this.tempMin);

  factory Main.fromJson(Map<String, dynamic> json)=> _$MainFromJson(json);


}

@JsonSerializable()
class Wind extends Object {

  final double speed;
  final double deg;
  //@JsonKey(nullable: true)
  //final double gust;


  Wind(this.speed, this.deg, );

  factory Wind.fromJson(Map<String, dynamic> json)=> _$WindFromJson(json);

}

@JsonSerializable()
class Rain {
  //Rain volume for last 3 hours
  @JsonKey(name: "3h")
  @JsonKey(nullable: true)
  final double threeHour;


  Rain(this.threeHour);

  factory Rain.fromJson(Map<String, dynamic> json)=>_$RainFromJson(json);


}

@JsonSerializable()
class Clouds extends Object{
  Clouds(this.all);
  final int all;
  factory Clouds.fromJson(Map<String, dynamic> json)=>_$CloudsFromJson(json);

}


@JsonSerializable()
class Weather extends Object {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather(this.id, this.main, this.description, this.icon);

  factory Weather.fromJson(Map<String, dynamic> json)=> _$WeatherFromJson(json);


}