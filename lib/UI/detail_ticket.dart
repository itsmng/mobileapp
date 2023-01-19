import 'package:flutter/material.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/form_fields.dart/button.dart';
import 'package:mobileapp/form_fields.dart/form_fields_ticket.dart';
import 'package:mobileapp/models/tickets_model.dart';

class DetailTicket extends StatefulWidget {
  const DetailTicket({super.key, required this.ticket});
  final Tickets ticket;

  @override
  State<DetailTicket> createState() => _DetailTicketState();
}

class _DetailTicketState extends State<DetailTicket> {
  final GlobalKey<FormState> _formKeyTicket = GlobalKey<FormState>();

  final formFieldsTicket = FormFieldsTicket();
  final buttonForm = Button();

  final TextEditingController _titleController = TextEditingController();

  Map<int, String> listPriority = {
    1: "Very low",
    2: "Low",
    3: "Medium",
    4: "High",
    5: "Very high",
    6: "Major"
  };
  late String selectedPriority;

  List<DropdownMenuItem<String>> get dropdownPriority {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Very low", child: Text("Very low")),
      const DropdownMenuItem(value: "Low", child: Text("Low")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "High", child: Text("High")),
      const DropdownMenuItem(value: "Very high", child: Text("Very high")),
      const DropdownMenuItem(value: "Major", child: Text("Major")),
    ];
    return menuItems;
  }

  final objectTicket = Tickets();
  dynamic responseAPI;
  Map updateData = {};

  final messages = Messages();

  @override
  void initState() {
    _titleController.text = widget.ticket.title.toString();
    selectedPriority = widget.ticket.priority.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
              key: _formKeyTicket,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  formFieldsTicket.buildTextField(_titleController, Icons.title,
                      "Title", TextInputType.text),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedPriority,
                          items: dropdownPriority,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPriority = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            prefixIcon:
                                Icon(Icons.priority_high, color: Colors.black),
                            focusColor: Colors.black,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.greenAccent),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            errorStyle: TextStyle(
                                color: Color.fromARGB(255, 245, 183, 177),
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buttonForm.buttonSave(
                    () async {
                      if (!_formKeyTicket.currentState!.validate()) {
                        return;
                      } else {
                        var priorityID = listPriority.keys.where((element) =>
                            listPriority[element] == selectedPriority);

                        updateData["name"] = _titleController.text;
                        updateData["priority"] = priorityID.first;

                        responseAPI = objectTicket.apiMgmt.put(
                            ApiEndpoint.apiUpdateTicket,
                            widget.ticket.id!,
                            updateData);

                        final apiResponseValue =
                            await responseAPI.then((val) => val["update"]);

                        if (apiResponseValue == "true") {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              "Item successfully updated: ${widget.ticket.title}",
                              context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TicketsPage(),
                          ));
                        } else if (apiResponseValue == "errorUpdate") {
                          if (!mounted) return;
                          messages.sendAlert(
                              "Error to update: Check API connexion", context);
                        } else {
                          if (!mounted) return;
                          messages.sendAlert("Update cancelled", context);
                        }
                      }
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
