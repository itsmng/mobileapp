import 'package:flutter/material.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/models/bar_model.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Tickets> futureTicket;
  late List<Computer> futureComputer;

  var ticket = Tickets();
  var computer = Computer();

  Map listTicketsData = {};
  Map<String, int> listComputerData = {};

  dynamic apiResponse, apiResponseComputer;

  @override
  void initState() {
    super.initState();
    apiResponse = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    apiResponseComputer = ticket.apiMgmt.get(ApiEndpoint.apiGetAllComputers);

    handleTickets();
    handleComputers();
  }

  List<charts.Series<BarMmodel, String>> _createTicketsChart() {
    List<BarMmodel> data = [];

    if (listTicketsData["new"] != null &&
        listTicketsData["processing (assigned)"] != null &&
        listTicketsData["processing (planned)"] != null &&
        listTicketsData["pending"] != null) {
      data = [
        BarMmodel(
            "New",
            listTicketsData["new"],
            charts.ColorUtil.fromDartColor(
                const Color.fromARGB(255, 78, 121, 167))),
        BarMmodel(
            "Assigned",
            listTicketsData["processing (assigned)"],
            charts.ColorUtil.fromDartColor(
                const Color.fromARGB(255, 242, 142, 44))),
        BarMmodel(
            "Planned",
            listTicketsData["processing (planned)"],
            charts.ColorUtil.fromDartColor(
                const Color.fromARGB(255, 225, 87, 89))),
        BarMmodel(
            "Pending",
            listTicketsData["pending"],
            charts.ColorUtil.fromDartColor(
                const Color.fromARGB(255, 118, 183, 178))),
      ];
    }

    return [
      charts.Series<BarMmodel, String>(
        data: data,
        id: 'graphTickets',
        colorFn: (BarMmodel barModeel, _) => barModeel.barColor,
        domainFn: (BarMmodel barModeel, _) => barModeel.title,
        measureFn: (BarMmodel barModeel, _) => barModeel.value,
      )
    ];
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
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    Text(
                      "Tickets status",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: charts.BarChart(
                        _createTicketsChart(),
                        animate: true,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(3),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Latest 24h",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            listTicketsData["latest tickets"].toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Late tickets",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            listTicketsData["late tickets"].toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: <Widget>[
                    Text(
                      "Computers status",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                      child: charts.PieChart<String>(
                        defaultRenderer:
                            charts.ArcRendererConfig(arcRendererDecorators: [
                          charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.outside)
                        ]),
                        _createComputerChart(),
                        animate: true,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
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
    int lateTickets = 0;
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

      if (element.timeToResolve != null) {
        DateTime resolveTime = DateTime.parse(element.timeToResolve.toString());
        if (resolveTime.isBefore(currentDate)) {
          lateTickets++;
        }
      }

      DateTime ticketDate = DateTime.parse(element.date.toString());
      diff = currentDate.difference(ticketDate);
      if (diff.inHours <= 24) {
        latestTickets++;
      }

      setState(() {
        listTicketsData["new"] = newTicket;
        listTicketsData["processing (assigned)"] = assignedTicket;
        listTicketsData["processing (planned)"] = plannedTickets;
        listTicketsData["pending"] = pendingTickets;
        listTicketsData["latest tickets"] = latestTickets;
        listTicketsData["late tickets"] = lateTickets;
      });
    }
  }

  handleComputers() async {
    futureComputer = await computer.fetchComputerData(apiResponseComputer);

    for (var element in futureComputer) {
      int cpt = 0;
      for (var ele in futureComputer) {
        if (ele.status == element.status) {
          cpt++;
        }
      }
      setState(() {
        listComputerData[element.status.toString()] = cpt;
      });
    }
  }

  List<charts.Series<BarMmodel, String>> _createComputerChart() {
    List<BarMmodel> data = [];
    List<Color> colors = [
      Colors.redAccent,
      Colors.teal,
      Colors.green,
      Colors.orangeAccent,
      Colors.grey,
      Colors.blueAccent,
      Colors.orange,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.purpleAccent
    ];
    int index = 0;
    if (listComputerData.isNotEmpty) {
      listComputerData.forEach((key, value) {
        data.add(BarMmodel(
            key, value, charts.ColorUtil.fromDartColor(colors[index])));
        index++;
      });
    }

    return [
      charts.Series<BarMmodel, String>(
        data: data,
        id: 'graphTickets',
        colorFn: (BarMmodel barModeel, _) => barModeel.barColor,
        domainFn: (BarMmodel barModeel, _) => barModeel.title,
        measureFn: (BarMmodel barModeel, _) => barModeel.value,
      )
    ];
  }
}
