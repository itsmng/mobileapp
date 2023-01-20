import 'package:flutter/material.dart';

class Button {
  buttonSave(VoidCallback? onClicked) {
    return ElevatedButton(
        //MaterialButton
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 245, 183, 177), // background
        ),
        onPressed: onClicked,
        child: const Text(
          'Save',
          style: TextStyle(
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
        child: const Text(
          'Delete',
          style: TextStyle(
              color: Color.fromARGB(255, 143, 90, 10),
              fontWeight: FontWeight.bold),
        ));
  }
}
