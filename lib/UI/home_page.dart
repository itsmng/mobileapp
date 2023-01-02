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
    int cptNew = 0;
    int cptAssigned = 0;
    int cptPlanned = 0;
    int cptPending = 0;
    int latestTickets = 0;

    DateTime currentDate = DateTime.now();
    Duration diff;
    for (var element in futureTicket) {
      if (element.status == 1) {
        cptNew++;
      } else if (element.status == 2) {
        cptAssigned++;
      } else if (element.status == 3) {
        cptPlanned++;
      } else if (element.status == 4) {
        cptPending++;
      }

      DateTime date = DateTime.parse(element.date.toString());
      diff = currentDate.difference(date);
      if (diff.inHours <= 24) {
        latestTickets++;
      }
    }

    listTicketsData["new"] = cptNew;
    listTicketsData["processing (assigned)"] = cptAssigned;
    listTicketsData["processing (planned)"] = cptPlanned;
    listTicketsData["pending"] = cptPending;
    listTicketsData["latest tickets"] = latestTickets;
  }
}
