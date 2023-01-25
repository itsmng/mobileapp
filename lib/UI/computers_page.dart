import 'package:flutter/material.dart';
import 'package:mobileapp/Data_table/row_source_computer.dart';
import 'package:mobileapp/UI/create_computer.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/multi_select.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/state_computer.dart';
import 'package:mobileapp/translations.dart';

class ComputersPage extends StatefulWidget {
  const ComputersPage({super.key});

  @override
  State<ComputersPage> createState() => _ComputersPageState();
}

class _ComputersPageState extends State<ComputersPage> {
  final computer = Computer();
  late List<Computer> dataComputers = [];
  dynamic apiRespComputer;

  List<Computer>? filterData;

  int? sortColumnIndex;
  bool isAscending = false;
  int rowPerPage = 8;

  final TextEditingController _searchController = TextEditingController();

  List<String> _selectedItems = [];
  // Default values of the tables
  late String firstHeaderNoCustomizable =
      Translations.of(context)!.text('name');
  late String secondHeaderCustomizable =
      Translations.of(context)!.text('status');
  late String thirdHeaderCustomizable =
      Translations.of(context)!.text('open_date');

  // Object of the Special Status class
  final _stateComputer = StateComputer();

  // Implement a multi select filter on the screen
  void _showMultiSelectFilter() async {
    // a list of selectable items
    // these items are fetched from a API
    final List<String> items = [];
    List<StateComputer> allStateComputer =
        await _stateComputer.getAllStateComputer();

    // Add all special status to items
    for (var state in allStateComputer) {
      items.add(state.name.toString());
    }

    if (!mounted) return;
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
        dataComputers = [];

        // Add the ferting elements in the list
        for (var element in _selectedItems) {
          for (var stat in allStateComputer) {
            if (element == stat.name) {
              dataComputers.addAll(filterData!
                  .where((element) => element.statusValue == stat.name)
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
      Translations.of(context)!.text('open_date'),
      Translations.of(context)!.text('serial'),
      Translations.of(context)!.text('location'),
      Translations.of(context)!.text('inventory'),
      Translations.of(context)!.text('source'),
      Translations.of(context)!.text('last_update'),
      Translations.of(context)!.text('technician'),
      Translations.of(context)!.text('user'),
      Translations.of(context)!.text('status'),
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

  void onsortColoumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      dataComputers.sort((a, b) => compareString(ascending, a.name!, b.name!));
    } else if (columnIndex == 1) {
      dataComputers.sort(
          (a, b) => compareString(ascending, a.statusValue!, b.statusValue!));
    } else if (columnIndex == 2) {
      dataComputers
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
    apiRespComputer = computer.apiMgmt.get(ApiEndpoint.apiGetAllComputers);
    getComputerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerMenu(),
      appBar: AppBar(
        title: Text(Translations.of(context)!.text('all_computers')),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: Translations.of(context)!.text('create_computer'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateComputer(),
              ));
            },
          )
        ],
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
                    decoration: InputDecoration(
                      hintText: Translations.of(context)!.text('search'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        dataComputers = filterData!
                            .where((element) => element.name!.contains(value))
                            .toList();
                      });
                    },
                  )),
              source: RowSourceComputer(
                myData: dataComputers,
                count: dataComputers.length,
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

  getComputerData() async {
    dataComputers = await computer.fetchComputerData(apiRespComputer);

    setState(() {
      dataComputers;
      filterData = dataComputers;
    });
  }
}
