/*
* author: Harsh Kukreja
*   This class uses RxCommand (Reactive Extension Command) which capsules a given handler function that can then be executed by its execute method or directly assigned to a widget's handler because it's a callable class. The result of this method is then published through its Observable interface
* */

import 'package:rx_command/rx_command.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import 'package:weatherapp/model/model.dart';
import 'package:weatherapp/model/weather_repo.dart';

class ModelCommand {
  final WeatherRepo weatherRepo;

  final RxCommand<Position, List<WeatherModel>> updateWeatherCommand;
  final RxCommand<void, bool> getGpsCommand;
  final RxCommand<bool, bool> radioCheckedCommand;
  final RxCommand<int, void> addCitiesCommand;
  final RxCommand<dynamic, Position> updateLocationCommand;

  ModelCommand._(
      this.weatherRepo,
      this.updateWeatherCommand,
      this.getGpsCommand,
      this.radioCheckedCommand,
      this.addCitiesCommand,
      this.updateLocationCommand,

      );

  factory ModelCommand(WeatherRepo repo) {
    final _getGpsCommand = RxCommand.createAsyncNoParam<bool>(repo.getGps);

    final _radioCheckedCommand = RxCommand.createSync<bool, bool>((b) => b);



    //Two Observables needed because they are only cold observables (single subscription).
    final _boolCombineA =
        CombineObs(_getGpsCommand, _radioCheckedCommand).combinedObservable;
    final _boolCombineB =
        CombineObs(_getGpsCommand, _radioCheckedCommand).combinedObservable;

    final _updateWeatherCommand =
    RxCommand.createAsync<Position, List<WeatherModel>>(repo.updateWeather,
        canExecute: _boolCombineA);

    final _addCitiesCommand = RxCommand.createSyncNoResult<int>(repo.addCities);

    final _updateLocationCommand =
    RxCommand.createAsync<dynamic, Position>(repo.updateLocation,
        canExecute: _boolCombineB);

    _updateLocationCommand.listen((data) => _updateWeatherCommand(data));



    return ModelCommand._(
      repo,
      _updateWeatherCommand,
      _getGpsCommand,
      _radioCheckedCommand,
      _addCitiesCommand,
      _updateLocationCommand,
    );
  }
}
class CombineObs {
  final Observable<bool> _combinedObservable;
  Observable<bool> get combinedObservable => _combinedObservable;
  CombineObs._(this._combinedObservable);

  factory CombineObs(a, b) {
    Observable<bool> c = Observable.combineLatest2(a, b, (x, y) => x && y);
    return CombineObs._(c);
  }
}
