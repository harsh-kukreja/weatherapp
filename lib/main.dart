/*
*author: Harsh Kukreja
*
* */
import 'package:flutter/material.dart';

import 'package:Forecasto/model/weather_repo.dart';
import 'package:Forecasto/model/model_command.dart';
import 'package:Forecasto/model/model.dart';
import 'package:Forecasto/model/model_provider.dart';

import 'package:rx_widgets/rx_widgets.dart';

import 'package:http/http.dart' as http;
void main() {

  final repo = WeatherRepo(client: http.Client());
  final modelCommand = ModelCommand(repo);
  print("Inside main");
  runApp(
    ModelProvider(
      child: MyApplication(),
      modelCommand: modelCommand,
    ),
  );
}

class MyApplication extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Demo',
      theme: ThemeData(
        primaryColor: Colors.white,

      ),
      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    ModelProvider.of(context).getGpsCommand.call();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,

        title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'image/icon.png',
            fit: BoxFit.cover,
            height: 37,
          ),
          Container(
              padding: const EdgeInsets.all(10.0), child: Text('Weather App'))
        ],

      ),
        actions: <Widget>[
          Container(
            child: Center(
              child: RxLoader<bool>(
                radius: 20.0,
                commandResults: ModelProvider.of(context).getGpsCommand.results,
                dataBuilder: (context, data) => Row(
                  children: <Widget>[
                    Text(data ? "GPS is Active" : "GPS is Inactive"),
                    IconButton(
                      icon: Icon(
                          data ? Icons.gps_fixed : Icons.gps_not_fixed),
                      onPressed: ModelProvider.of(context).getGpsCommand,
                    ),
                  ],
                ),
                placeHolderBuilder: (context) => Text("Puch the button"),
                errorBuilder: (context,exception) =>Text("From GPS $exception"),
              ),
            ),
          ),

          PopupMenuButton<int>(

            padding: EdgeInsets.all(1),
            tooltip: "Select How much data you want",
            onSelected: (int item){
              ModelProvider.of(context).addCitiesCommand(item);
            },
            itemBuilder: (context){
              return menuMembers.map((number) => PopupMenuItem(

                value: number,
                child: Center(

                  child: Text(
                    number.toString(),
                  ),
                ),
              )).toList(); 
            },
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: RxLoader(
              radius: 30,
              commandResults: ModelProvider.of(context).updateWeatherCommand.results,
              dataBuilder: (context,data) => WeatherList(data),
              placeHolderBuilder: (context) => Center(child: Text("No Data"),),
              errorBuilder: (context,exception) => Center(child: Text(" $exception"),),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10) ,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: WidgetSelector(
                    buildEvents: ModelProvider
                      .of(context)
                    .updateWeatherCommand
                    .canExecute,
                    onTrue: MaterialButton(
                      elevation: 5,
                      color: Colors.orangeAccent,
                      child: Text("Get The Weather"),
                      onPressed: ModelProvider.of(context).updateLocationCommand.call,

                    ),
                    onFalse: MaterialButton(
                      elevation: 0,
                        color: Colors.orangeAccent,
                        onPressed: null,
                        child: Text("Loading Data.. "),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Column(
                    children: <Widget>[
                      SliderItem(
                        sliderState: true,
                        command: ModelProvider.of(context).radioCheckedCommand,

                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text("Turn Off Data"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
const int deg = 0x00B0;
const int C = 0x43;
class WeatherList extends StatelessWidget{
  final List<WeatherModel> list;

  WeatherList(this.list);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context,index) {
        return Card(

          child: ListTile(
            leading: Image.network("http://openweathermap.org/img/w/"+list[index].icon.toString()+".png"),


            title: Container(
              padding: EdgeInsets.all(10),
              child: Text(list[index].city.toString()),
            ),
            subtitle: Container(
              padding: EdgeInsets.all(10),
              child: Text("Temperature "+list[index].temperature.toString()+" "+String.fromCharCode(deg) + String.fromCharCode(C)),
            ),
            trailing: Container(
              child: Column(
                children: <Widget>[
                  Text(list[index].description),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Latitude: ${list[index].lat}",
                      style: TextStyle(
                        fontSize: 12,fontStyle: FontStyle.italic,
                      ),

                    ),
                  ),
                  Container(

                    child: Text(
                      "Longitude: ${list[index].long}",
                      style: TextStyle(
                        fontSize: 12,fontStyle: FontStyle.italic,
                      ),

                    ),
                  ),
                ],
              ),
            ),

          ),

        );
      },

    );
  }
}

class SliderItem extends StatefulWidget {
  final bool sliderState;
  final ValueChanged<bool> command;

  SliderItem({this.sliderState, this.command});

  @override
  _SliderItemState createState() => _SliderItemState(sliderState,command);
}

class _SliderItemState extends State<SliderItem> {
   bool sliderState;
  ValueChanged<bool> command;

  _SliderItemState(this.sliderState, this.command);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: sliderState,
      onChanged: (item){
        setState(() {
          sliderState =item;
        });
        command(item);
      },
    );
  }
}
final List<int> menuMembers = <int>[5,10,15,20,25,30,40,45,50];
