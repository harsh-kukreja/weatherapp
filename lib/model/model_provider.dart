/*
* author: Harsh Kukreja
*
* */
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:Forecasto/model/model_command.dart';

class ModelProvider extends InheritedWidget{
  final ModelCommand modelCommand;

  ModelProvider({Key key, @required this.modelCommand, @required Widget child}): assert(modelCommand != null),
          super(key: key, child: child);

  @override
  bool updateShouldNotify(ModelProvider oldWidget) {
    // TODO: implement updateShouldNotify
    return modelCommand != oldWidget.modelCommand;
  }

   static ModelCommand of(BuildContext context){
      ModelProvider modelProvider = context.inheritFromWidgetOfExactType(ModelProvider) as ModelProvider;

      return modelProvider.modelCommand;
   }
}