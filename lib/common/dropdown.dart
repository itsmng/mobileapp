import 'package:flutter/material.dart';

class Dropdown {
  List<DropdownMenuItem<String>> dropdownItem(Map<int, String> listItems) {
    List<DropdownMenuItem<String>> menuItems = [];

    for (var ele in listItems.values) {
      menuItems.add(
        DropdownMenuItem(value: ele, child: Text(ele)),
      );
    }

    return menuItems;
  }
}
