import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Widget buildTextAreaField(
    TextEditingController controllerField,
    IconData iconData,
    String labelTextField,
    TextInputType inputType,
  ) {
    return TextFormField(
      controller: controllerField,
      minLines: 5,
      maxLines: 10,
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

  Widget buildDateTimeField(TextEditingController controllerField,
      String labelTextField, BuildContext context) {
    return TextFormField(
      controller: controllerField,
      readOnly: true,
      showCursor: false,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.date_range, color: Colors.black),
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
      keyboardType: TextInputType.datetime,
      validator: (String? value) {
        if (value.toString().isEmpty) {
          return '$labelTextField is Required';
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
      onTap: () async {
        DateTime? date = DateTime(1900);
        FocusScope.of(context).requestFocus(FocusNode());
        date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));

        if (date != null) {
          String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
          controllerField.text = formattedDate.toString();
        }
      },
    );
  }
}
