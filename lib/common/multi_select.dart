// Multi Select widget
// This widget is reusable
import 'package:flutter/material.dart';
import 'package:mobileapp/api/model.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final String type;
  final String model;
  const MultiSelect(
      {Key? key, required this.items, required this.type, required this.model})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  final List<String> _selectedHeaders = [];
  final List<String> _selectedfilter = [];
  late List<String> _listSelected = [];
  final message = Messages();

  @override
  void initState() {
    _setSelectedFields();
    _setSelectedFilter();
    super.initState();
  }

  _setSelectedFields() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.model == "Ticket") {
        _selectedHeaders.addAll(prefs.getStringList("customHeadersTicket")!);
      } else if (widget.model == "Computer") {
        _selectedHeaders.addAll(prefs.getStringList("customHeadersComputer")!);
      }
    });
  }

  _setSelectedFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.model == "Ticket") {
        _selectedfilter.addAll(prefs.getStringList("selectedFilterTicket")!);
      } else if (widget.model == "Computer") {
        _selectedfilter.addAll(prefs.getStringList("selectedFilterComputer")!);
      }
    });
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
        _selectedHeaders.add(itemValue);
        _selectedfilter.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
        _selectedHeaders.remove(itemValue);
        _selectedfilter.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    if (_selectedItems.isNotEmpty) {
      Navigator.pop(context, _selectedItems);
    } else {
      message.sendAlert(
          Translations.of(context)!.text('message_no_item_selected'), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == "Editor") {
      var initSession = InitSession();
      initSession.apiMgmt
          .saveListStringData("customHeadersTicket", _selectedHeaders);
      _listSelected = _selectedHeaders;
    } else if (widget.type == "Filter") {
      _listSelected = _selectedfilter;
    }

    return AlertDialog(
      title: const Text('Select Status'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _listSelected.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
