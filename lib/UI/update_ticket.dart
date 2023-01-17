import 'package:flutter/material.dart';
import 'package:mobileapp/models/tickets_model.dart';

class UpdateTicket extends StatefulWidget {
  const UpdateTicket({super.key, required this.ticket});
  final Tickets ticket;

  @override
  State<UpdateTicket> createState() => _UpdateTicketState();
}

class _UpdateTicketState extends State<UpdateTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Ticket'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Title: ${widget.ticket.title.toString()}"),
            Text("Status:  ${widget.ticket.statusValue.toString()}"),
          ],
        ),
      ),
    );
  }
}
