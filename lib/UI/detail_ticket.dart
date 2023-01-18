import 'package:flutter/material.dart';
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

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.ticket.title.toString();

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
                ],
              )),
        ),
      ),
    );
  }
}
