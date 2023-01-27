import 'package:flutter/material.dart';
import 'package:mobileapp/translations.dart';

class Button {
  BuildContext context;
  Button(this.context);
  buttonSave(VoidCallback? onClicked) {
    return ElevatedButton(
        //MaterialButton
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 245, 183, 177), // background
        ),
        onPressed: onClicked,
        child: Text(
          Translations.of(context)!.text('button_valider'),
          style: const TextStyle(
              color: Color.fromARGB(255, 143, 90, 10),
              fontWeight: FontWeight.bold),
        ));
  }

  buttonDelete(VoidCallback? onClicked) {
    return ElevatedButton(
        //MaterialButton
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 245, 183, 177), // background
        ),
        onPressed: onClicked,
        child: Text(
          Translations.of(context)!.text('button_delete'),
          style: const TextStyle(
              color: Color.fromARGB(255, 143, 90, 10),
              fontWeight: FontWeight.bold),
        ));
  }

  buttonExit(VoidCallback? onClicked) {
    return ElevatedButton(
        //MaterialButton
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 245, 183, 177), // background
        ),
        onPressed: onClicked,
        child: Text(
          Translations.of(context)!.text('button_exit'),
          style: const TextStyle(
              color: Color.fromARGB(255, 143, 90, 10),
              fontWeight: FontWeight.bold),
        ));
  }
}
