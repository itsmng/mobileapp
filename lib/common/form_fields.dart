import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Class to create a field in a form
class BuildFormFields {
  Widget buildTextField(
      TextEditingController controllerField,
      IconData iconData,
      String labelTextField,
      TextInputType inputType,
      bool isRequired) {
    // This function is triggered when the clear buttion is pressed
    void clearTextField() {
      // Clear everything in the text field
      controllerField.clear();
    }

    /// Create a text field in a form
    return TextFormField(
      controller: controllerField,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.black),
        suffixIcon: controllerField.text.isEmpty
            ? null // Show nothing if the text field is empty
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: clearTextField,
              ), // Show the clear button if the text field has something
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
        if (value.toString().isEmpty && isRequired == true) {
          return '$labelTextField is Required';
        }
        return null;
      },
      onSaved: (String? val) {
        controllerField.text = val!;
      },
      style: const TextStyle(color: Colors.black),
    );
  }

  /// Create text area in a form
  Widget buildTextAreaField(
      TextEditingController controllerField,
      IconData iconData,
      String labelTextField,
      TextInputType inputType,
      bool isRequired) {
    // This function is triggered when the clear buttion is pressed
    void clearTextField() {
      // Clear everything in the text field
      controllerField.clear();
    }

    return TextFormField(
      controller: controllerField,
      minLines: 3,
      maxLines: 5,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.black),
        suffixIcon: controllerField.text.isEmpty
            ? null // Show nothing if the text field is empty
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: clearTextField,
              ),
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
        if (value.toString().isEmpty && isRequired == true) {
          return '$labelTextField is Required';
        }
        return null;
      },
      onSaved: (String? val) {
        controllerField.text = val!;
      },
      style: const TextStyle(color: Colors.black),
    );
  }

  /// Create date time field in a form
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
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color.fromARGB(255, 123, 8, 29),
              )),
              child: child!,
            );
          },
        ));

        if (date != null) {
          String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
          controllerField.text = formattedDate.toString();
        }
      },
    );
  }
}
