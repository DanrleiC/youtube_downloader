import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class Loading {
  
  static void show({required BuildContext context}){
    Loader.show(context, progressIndicator: const CircularProgressIndicator(
        color: Color.fromARGB(255, 99, 46, 109),
      ));
  }

  static void hide(){
    Loader.hide();
  }
}