import 'package:flutter/material.dart';

/// Class to create a text form field
class FormFieldsTicket {
  Widget buildTextField(
    TextEditingController controllerField,
    IconData iconData,
    String labelTextField,
    TextInputType inputType,
  ) {
    return TextFormField(
      controller: controllerField,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.black),
        focusColor: Colors.black,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.greenAccent),
        ),
        labelText: labelTextField,
        labelStyle: const TextStyle(color: Colors.black),
        errorStyle: const TextStyle(
            color: Color.fromARGB(255, 245, 183, 177),
            fontStyle: FontStyle.italic),
      ),
      keyboardType: inputType,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return '$labelTextField is Required';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
    );
  }
}
