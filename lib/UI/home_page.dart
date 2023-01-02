import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/models/tickets_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Tickets> futureTicket;
  var ticket = Tickets();
  var listTicketsData = {};
  // ignore: prefer_typing_uninitialized_variables
  var apiResponse;

  @override
  void initState() {
    super.initState();
    apiResponse = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    handleTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text("Home"),
      ),
    );
  }

  handleTickets() async {
    futureTicket = await ticket.fetchTicketsData(apiResponse);
    int newTicket = 0;
    int assignedTicket = 0;
    int plannedTickets = 0;
    int pendingTickets = 0;
    int latestTickets = 0;
 

    if (kDebugMode) {
      DateTime currentDate = DateTime.now();
      late Duration diff;
      for (var element in futureTicket) {
        if (element.status == 1) {
          newTicket++;
        } else if (element.status == 2) {
          assignedTicket++;
        } else if (element.status == 3) {
          plannedTickets++;
        } else if (element.status == 4) {
          pendingTickets++;
        }

        DateTime ticketDate = DateTime.parse(element.date.toString());
        diff = currentDate.difference(ticketDate);
        if (diff.inHours <= 24) {
          latestTickets++;
        }
      }

      listTicketsData["new"] = newTicket;
      listTicketsData["processing (assigned)"] = assignedTicket;
      listTicketsData["processing (planned)"] = plannedTickets;
      listTicketsData["pending"] = pendingTickets;
      listTicketsData["latest tickets"] = latestTickets;
      }
  }
}
