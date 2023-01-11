import 'package:flutter/material.dart';
import 'package:mobileapp/Data_table/row_source_ticket.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/models/tickets_model.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
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
      filterData!.sort((a, b) => compareString(ascending, a.title!, b.title!));
    } else if (columnIndex == 1) {
      filterData!
          .sort((a, b) => compareString(ascending, a.category!, b.category!));
    } else if (columnIndex == 2) {
      filterData!
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
        title: const Text('Tickets'),
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
              ),
              rowsPerPage: rowPerPage,
              columnSpacing: 8,
              columns: [
                rowDataColumn("Titile"),
                rowDataColumn("Category"),
                rowDataColumn("Location"),
              ],
            ),
          )),
    );
  }

  DataColumn rowDataColumn(String cell) {
    return DataColumn(
        label: Text(
          cell,
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
