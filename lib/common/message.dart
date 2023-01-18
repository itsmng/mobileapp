import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Messages {
  messageBottomBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  sendAlert(String messageAlert, BuildContext context) {
    return Alert(
      context: context,
      desc: messageAlert,
      style: const AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          color: const Color.fromARGB(255, 245, 183, 177),
          onPressed: () => Navigator.pop(context),
          width: 90,
          child: const Text(
            'Valider',
            style: TextStyle(
                color: Color.fromARGB(255, 143, 90, 10),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    ).show();
  }
}
