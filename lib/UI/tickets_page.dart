import 'package:flutter/material.dart';
import 'package:mobileapp/Data_table/row_source_ticket.dart';
import 'package:mobileapp/UI/create_ticket.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/model.dart';
import 'package:mobileapp/common/multi_select.dart';
import 'package:mobileapp/translations.dart';
import 'package:mobileapp/models/special_status.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<String> _selectedItems = [];
  static final _initSession = InitSession();

  // Default values of the tables
  late String firstHeaderNoCustomizable =
      Translations.of(context)!.text('title');
  late String secondHeaderCustomizable =
      Translations.of(context)!.text('status');
  late String thirdHeaderCustomizable =
      Translations.of(context)!.text('open_date');

  // Object of the Special Status class
  final _specialStatus = SpecialStatus();

  // Implement a multi select filter on the screen
  void _showMultiSelectFilter() async {
    // a list of selectable items
    // these items are fetched from a API
    final List<String> items = [];
    List<SpecialStatus> allSpecialStatus =
        await _specialStatus.getAllSpecialStatus();

    // Add all special status to items
    for (var specialStatus in allSpecialStatus) {
      items.add(specialStatus.name.toString());
    }
    final List<String> listSelectedFilter = [];
    if (!mounted) return;
    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          type: 'Filter',
          model: "Ticket",
        );
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;

        // Remove elements of the list
        dataTickets = [];

        // Add the ferting elements in the list
        for (var element in _selectedItems) {
          for (var stat in allSpecialStatus) {
            if (element == stat.name) {
              dataTickets.addAll(filterData!
                  .where((element) => element.statusID == stat.id)
                  .toList());
              listSelectedFilter.add(element);
              _initSession.apiMgmt.saveListStringData(
                  "selectedFilterTicket", listSelectedFilter);
            }
          }
        }
      });
    }
  }

  // Implement a multi select edit field on the screen
  void _showMultiSelectEditFiled() async {
    // a list of selectable items
    final List<String> items = [
      "ID",
      Translations.of(context)!.text('open_date'),
      Translations.of(context)!.text('status'),
      Translations.of(context)!.text('category'),
      Translations.of(context)!.text('location'),
      Translations.of(context)!.text('entity'),
      Translations.of(context)!.text('priority'),
      Translations.of(context)!.text('last_update'),
      Translations.of(context)!.text('recipient'),
    ];
    final List<String> selectedList = [];

    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          type: 'Editor',
          model: 'Ticket',
        );
      },
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;

        // If we select two element
        if (_selectedItems.length == 2) {
          secondHeaderCustomizable = _selectedItems[0];
          thirdHeaderCustomizable = _selectedItems[1];

          selectedList.add(_selectedItems[0]);
          selectedList.add(_selectedItems[1]);
          _initSession.apiMgmt
              .saveListStringData("customHeadersTicket", selectedList);
        } else {
          // If we select one element it's fixed in the third postion of the table
          if (secondHeaderCustomizable ==
              prefs.getStringList("customHeadersTicket")![0]) {
            secondHeaderCustomizable =
                prefs.getStringList("customHeadersTicket")![0];
            thirdHeaderCustomizable =
                prefs.getStringList("customHeadersTicket")![1];
          } else {
            secondHeaderCustomizable =
                prefs.getStringList("customHeadersTicket")![1];
            thirdHeaderCustomizable =
                prefs.getStringList("customHeadersTicket")![0];
          }
        }
      });
    }
  }

  final ticket = Tickets();
  late List<Tickets> dataTickets = [];
  dynamic apiRespTicket;

  List<Tickets>? filterData;

  int? sortColumnIndex;
  bool isAscending = false;
  int rowPerPage = 8;

  final TextEditingController _searchController = TextEditingController();

  void onsortColoumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      dataTickets.sort((a, b) => compareString(ascending, a.title!, b.title!));
    } else if (columnIndex == 1 &&
        (secondHeaderCustomizable ==
                Translations.of(context)!.text('open_date') ||
            secondHeaderCustomizable ==
                Translations.of(context)!.text('last_update'))) {
      dataTickets.sort((a, b) => compareString(ascending, a.date!, b.date!));
    } else if (columnIndex == 2 &&
        (thirdHeaderCustomizable ==
                Translations.of(context)!.text('open_date') ||
            thirdHeaderCustomizable ==
                Translations.of(context)!.text('last_update'))) {
      dataTickets.sort((a, b) => compareString(ascending, a.date!, b.date!));
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String s, String t) {
    return ascending ? s.compareTo(t) : t.compareTo(s);
  }

  @override
  void initState() {
    apiRespTicket = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    getTicketData();
    _initSession.apiMgmt
        .saveListStringData("customHeadersTicket", ["Status", "Open date"]);
    _initSession.apiMgmt.saveListStringData("selectedFilterTicket", ["New"]);
    super.initState();
  }

  double progress = 0.5;

  @override
  Widget build(BuildContext context) {
    final ticket = Tickets();
    return Scaffold(
      drawer: const NavigationDrawerMenu(),
      appBar: AppBar(
        title: Text(Translations.of(context)!.text('all_tickets')),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: Translations.of(context)!.text('create_ticket'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTicket(ticket: ticket),
              ));
            },
          )
        ],
      ),
      body: dataTickets.isEmpty
          ? Center(
              child: CircularProgressIndicator(value: progress),
            )
          : Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              width: double.infinity,
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  actions: <IconButton>[
                    IconButton(
                      color: const Color.fromARGB(255, 123, 8, 29),
                      icon: const Icon(Icons.filter_alt_outlined),
                      onPressed: _showMultiSelectFilter,
                    ),
                    IconButton(
                      color: const Color.fromARGB(255, 123, 8, 29),
                      icon: const Icon(Icons.mode_edit),
                      onPressed: _showMultiSelectEditFiled,
                    ),
                  ],
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: isAscending,
                  header: Container(
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: Translations.of(context)!.text('search'),
                        ),
                        onChanged: (value) {
                          setState(() {
                            dataTickets = filterData!
                                .where(
                                    (element) => element.title!.contains(value))
                                .toList();
                          });
                        },
                      )),
                  source: RowSourceTicket(
                    myData: dataTickets,
                    count: dataTickets.length,
                    customSecondHeader: secondHeaderCustomizable,
                    customThirdHeader: thirdHeaderCustomizable,
                    context: context,
                  ),
                  rowsPerPage: rowPerPage,
                  columnSpacing: 8,
                  columns: [
                    tableHeaders(firstHeaderNoCustomizable),
                    tableHeaders(secondHeaderCustomizable),
                    tableHeaders(thirdHeaderCustomizable),
                  ],
                ),
              )),
    );
  }

  DataColumn tableHeaders(String name) {
    // Replace the underscore by space
    if (name.contains("_")) {
      name = name.replaceAll("_", " ");
    }

    return DataColumn(
        label: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        onSort: onsortColoumn);
  }

  getTicketData() async {
    dataTickets = await ticket.fetchTicketsData(apiRespTicket);
    setState(() {
      dataTickets;
      filterData = dataTickets;
    });
  }
}
