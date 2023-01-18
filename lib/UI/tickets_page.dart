import 'package:flutter/material.dart';
import 'package:mobileapp/Data_table/row_source_ticket.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/multi_select.dart';
import 'package:mobileapp/models/special_status.dart';
import 'package:mobileapp/models/tickets_model.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<String> _selectedItems = [];

  // Default values of the tables
  late String firstHeaderNoCustomizable = "Title";
  late String secondHeaderCustomizable = "Status";
  late String thirdHeaderCustomizable = "Open_date";

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

    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
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
      "Category",
      "Location",
      "Entity",
      "Status",
      "Priority",
      "Open date",
      "Last update",
    ];

    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;

        // If we select one element it's fixed in the third postion of the table
        thirdHeaderCustomizable = _selectedItems[0];

        // If we select two element
        if (_selectedItems.length == 2) {
          secondHeaderCustomizable = _selectedItems[0];
          thirdHeaderCustomizable = _selectedItems[1];
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
    } else if (columnIndex == 1) {
      dataTickets
          .sort((a, b) => compareString(ascending, a.category!, b.category!));
    } else if (columnIndex == 2) {
      dataTickets
          .sort((a, b) => compareString(ascending, a.location!, b.location!));
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('All tickets'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
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
                    decoration: const InputDecoration(
                      hintText: "Search",
                    ),
                    onChanged: (value) {
                      setState(() {
                        dataTickets = filterData!
                            .where((element) => element.title!.contains(value))
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
