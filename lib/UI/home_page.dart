import 'package:flutter/material.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/models/bar_model.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mobileapp/translations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Tickets> futureTicket;
  late List<Computer> futureComputer;
  late Future<List<Tickets>> futurTicketExist;
  var ticket = Tickets();
  var computer = Computer();

  Map<String, int> listTicketsData = {};
  Map<String, int> listComputerData = {};

  dynamic apiResponseTicket, apiResponseComputer;

  double progress = 0.7;

  @override
  void initState() {
    apiResponseTicket = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    apiResponseComputer = computer.apiMgmt.get(ApiEndpoint.apiGetAllComputers);
    futurTicketExist = ticket.fetchTicketsData(apiResponseTicket);
    handleTickets();
    handleComputers();
    super.initState();
  }

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    apiResponseTicket = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    apiResponseComputer = computer.apiMgmt.get(ApiEndpoint.apiGetAllComputers);
    futurTicketExist = ticket.fetchTicketsData(apiResponseTicket);
    handleTickets();
    handleComputers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawerMenu(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 123, 8, 29),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(Translations.of(context)!.text('home_title')),
        ),
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: FutureBuilder(
              future: futurTicketExist,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (_, index) => Column(
                      children: [
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: <Widget>[
                                Text(
                                  Translations.of(context)!
                                      .text('ticket_status_title'),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        Translations.of(context)!
                                            .text('latest_24h'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        listTicketsData["Latest tickets"]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        Translations.of(context)!
                                            .text('late_tickets'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        listTicketsData["Late tickets"]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                                  Translations.of(context)!
                                      .text('computers_status_title'),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Expanded(
                                  child: charts.PieChart<String>(
                                    defaultRenderer: charts.ArcRendererConfig(
                                        arcRendererDecorators: [
                                          charts.ArcLabelDecorator(
                                              labelPosition: charts
                                                  .ArcLabelPosition.outside)
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
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }

  handleTickets() async {
    futureTicket = await ticket.fetchTicketsData(apiResponseTicket);

    int newTicket = 0;
    int assignedTicket = 0;
    int plannedTickets = 0;
    int pendingTickets = 0;
    int latestTickets = 0;
    int lateTickets = 0;
    DateTime currentDate = DateTime.now();
    late Duration diff;
    listTicketsData["Latest tickets"] = 0;
    listTicketsData["Late tickets"] = 0;

    for (var element in futureTicket) {
      if (element.statusID == 1) {
        newTicket++;
      } else if (element.statusID == 2) {
        assignedTicket++;
      } else if (element.statusID == 3) {
        plannedTickets++;
      } else if (element.statusID == 4) {
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
        listTicketsData[Translations.of(context)!.text('new_ticket')] =
            newTicket;
        listTicketsData[Translations.of(context)!.text('assigned_ticket')] =
            assignedTicket;
        listTicketsData[Translations.of(context)!.text('planned_ticket')] =
            plannedTickets;
        listTicketsData[Translations.of(context)!.text('pending_ticket')] =
            pendingTickets;

        listTicketsData["Latest tickets"] = latestTickets;
        listTicketsData["Late tickets"] = lateTickets;
      });
    }
  }

  List<charts.Series<BarMmodel, String>> _createTicketsChart() {
    List<BarMmodel> data = [];

    List<Color> colors = [
      const Color.fromARGB(255, 78, 121, 167),
      const Color.fromARGB(255, 242, 142, 44),
      const Color.fromARGB(255, 225, 87, 89),
      const Color.fromARGB(255, 118, 183, 178)
    ];
    int index = 0;
    if (listTicketsData.isNotEmpty) {
      listTicketsData.forEach((key, value) {
        if (key != "Late tickets" && key != "Latest tickets") {
          data.add(BarMmodel(
              key, value, charts.ColorUtil.fromDartColor(colors[index])));
          index++;
        }
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

  handleComputers() async {
    futureComputer = await computer.fetchComputerData(apiResponseComputer);

    for (var element in futureComputer) {
      int cpt = 0;
      for (var ele in futureComputer) {
        if (ele.statusID == element.statusID) {
          cpt++;
        }
      }
      setState(() {
        listComputerData[element.statusID.toString()] = cpt;
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
        if (key.isEmpty) {
          key = Translations.of(context)!.text('without_status');
        }
        data.add(BarMmodel(
            key, value, charts.ColorUtil.fromDartColor(colors[index])));
        index++;
      });
      return [
        charts.Series<BarMmodel, String>(
          data: data,
          id: 'graphComputers',
          colorFn: (BarMmodel barModeel, _) => barModeel.barColor,
          domainFn: (BarMmodel barModeel, _) =>
              "${barModeel.value} - ${barModeel.title}",
          measureFn: (BarMmodel barModeel, _) => barModeel.value,
        )
      ];
    } else {
      data.add(BarMmodel(
          Translations.of(context)!.text('message_no_item_found'),
          1,
          charts.ColorUtil.fromDartColor(Colors.red)));
      return [
        charts.Series<BarMmodel, String>(
          data: data,
          id: 'graphComputers',
          colorFn: (BarMmodel barModeel, _) => barModeel.barColor,
          domainFn: (BarMmodel barModeel, _) => barModeel.title,
          measureFn: (BarMmodel barModeel, _) => barModeel.value,
        )
      ];
    }
  }
}
