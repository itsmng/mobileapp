import 'package:flutter/material.dart';
import 'package:mobileapp/Data_table/row_source_computer.dart';
import 'package:mobileapp/UI/create_computer.dart';
import 'package:mobileapp/UI/navigation_drawer.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/api/model.dart';
import 'package:mobileapp/common/multi_select.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/state_computer.dart';
import 'package:mobileapp/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComputersPage extends StatefulWidget {
  const ComputersPage({super.key});

  @override
  State<ComputersPage> createState() => _ComputersPageState();
}

class _ComputersPageState extends State<ComputersPage> {
  final computer = Computer();
  late List<Computer> dataComputers = [];
  dynamic apiRespComputer;
  static final _initSession = InitSession();

  List<Computer>? filterData;

  int? sortColumnIndex;
  bool isAscending = false;
  int rowPerPage = 8;

  late Future<List<Computer>> futurComputerExist;

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

    final List<String> listSelectedFilter = [];
    if (!mounted) return;
    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          type: 'Filter',
          model: 'Computer',
        );
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
              listSelectedFilter.add(element);
              _initSession.apiMgmt.saveListStringData(
                  "selectedFilterComputer", listSelectedFilter);
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
    final List<String> selectedList = [];

    // Get the list of selected item
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          type: 'Editor',
          model: 'Computer',
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
              .saveListStringData("customHeadersComputer", selectedList);
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

  void onsortColoumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      dataComputers.sort((a, b) => compareString(ascending, a.name!, b.name!));
    } else if (columnIndex == 1 &&
        (secondHeaderCustomizable ==
                Translations.of(context)!.text('open_date') ||
            secondHeaderCustomizable ==
                Translations.of(context)!.text('last_update'))) {
      dataComputers.sort((a, b) => compareString(ascending, a.date!, b.date!));
    } else if (columnIndex == 2 &&
        (thirdHeaderCustomizable ==
                Translations.of(context)!.text('open_date') ||
            thirdHeaderCustomizable ==
                Translations.of(context)!.text('last_update'))) {
      dataComputers.sort((a, b) => compareString(ascending, a.date!, b.date!));
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
    setDefaultSelectedheaders();
    _initSession.apiMgmt
        .saveListStringData("selectedFilterComputer", ["Production"]);

    futurComputerExist = computer.fetchComputerData(apiRespComputer);
    super.initState();
  }

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    setState(() {
      apiRespComputer = computer.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
      getComputerData();

      _initSession.apiMgmt.saveListStringData("selectedFilterTicket", ["New"]);

      futurComputerExist = computer.fetchComputerData(apiRespComputer);
    });
  }

  setDefaultSelectedheaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("customHeadersComputer") == null ||
        prefs.getStringList("customHeadersComputer")!.isEmpty) {
      _initSession.apiMgmt.saveListStringData("customHeadersComputer",
          [secondHeaderCustomizable, thirdHeaderCustomizable]);
    } else {
      secondHeaderCustomizable =
          prefs.getStringList("customHeadersComputer")![0];
      thirdHeaderCustomizable =
          prefs.getStringList("customHeadersComputer")![1];
    }
  }

  double progress = 0.5;

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
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: FutureBuilder(
            future: futurComputerExist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (_, index) => Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                                  hintText:
                                      Translations.of(context)!.text('search'),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    dataComputers = filterData!
                                        .where((element) =>
                                            element.name!.contains(value))
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
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
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
