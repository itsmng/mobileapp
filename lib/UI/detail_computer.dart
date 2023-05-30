import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobileapp/UI/computers_page.dart';
import 'package:mobileapp/UI/create_ticket.dart';
import 'package:mobileapp/UI/detail_ticket.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/button.dart';
import 'package:mobileapp/common/dropdown.dart';
import 'package:mobileapp/common/form_fields.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/entity.dart';
import 'package:mobileapp/models/item_ticket.dart';
import 'package:mobileapp/models/location.dart';
import 'package:mobileapp/models/state_computer.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:mobileapp/models/update_source.dart';
import 'package:mobileapp/models/user.dart';
import 'package:mobileapp/translations.dart';

import '../models/special_status.dart';

class DetailComputer extends StatefulWidget {
  const DetailComputer({super.key, required this.computer});
  final Computer computer;

  @override
  State<DetailComputer> createState() => _DetailComputerState();
}

class _DetailComputerState extends State<DetailComputer> {
  final GlobalKey<FormState> _formKeyComputer = GlobalKey<FormState>();

  final formFieldsComputer = BuildFormFields();

  final objectComputer = Computer();
  dynamic responseAPI;
  dynamic responseAPIDelete;

  Map updateData = {};

  final messages = Messages();
  final dropdown = Dropdown();

  Map<int, String> listStatus = {};
  late int? selectedStatus;

  Map<int, String> listTicketStatus = {};
  late String selectedTicketStatus;

  Map<int, String> listEntities = {};
  late int? selectedEntity;

  Map<int, String> listLocations = {};
  late int? selectedLocation;

  Map<int, String> listUpdateSource = {};
  late String selectedUpdateSource;

  Map<int, String> listUsersInCharge = {};
  late int? selectedUserInCharge;

  Map<int, String> listUsers = {};
  late int? selectedUser;

  List<ItemTicket> allItemsTickets = [];
  dynamic responseAPIAddFollowup;

  List<Tickets> allTicketsWithComputer = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _otherSerialController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.computer.name.toString();
    _serialController.text = widget.computer.serial.toString();
    _otherSerialController.text = widget.computer.otherSerial.toString();
    _commentController.text = widget.computer.comment.toString();

    selectedStatus = widget.computer.statusID;
    selectedEntity = widget.computer.entity;
    selectedLocation = widget.computer.location;
    selectedUpdateSource = widget.computer.source.toString();
    selectedUserInCharge = widget.computer.userIdTech;
    selectedUser = widget.computer.userID;

    getAllStatus();
    getAllTicketStatus();
    getAllEntities();
    getAllLocations();
    getAllUpdateSource();
    getAllUsersInCharge();
    getAllUsers();
    //getAllItemsTickets();
    getAllItemsTicketsByComputer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Tickets linkedTicket = Tickets(
      associatedElement: widget.computer.name,
    );
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Translations.of(context)!.text('computer')),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 123, 8, 29),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              tooltip: Translations.of(context)!.text('back'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ComputersPage(),
                ));
              },
            ),
            bottom: TabBar(
              labelStyle: const TextStyle(color: Colors.white),
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(text: Translations.of(context)!.text('computer')),
                Tab(text: Translations.of(context)!.text('ticket')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              updateComputer(),
              displayAllItemsTickets(),
            ],
          ),
          floatingActionButton: SpeedDial(
              mini: true,
              icon: Icons.add,
              foregroundColor: Colors.white,
              activeIcon: Icons.close,
              visible: true,
              animationDuration: const Duration(milliseconds: 5),
              animatedIconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 123, 8, 29),
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.task),
                  label: Translations.of(context)!.text('create_ticket'),
                  backgroundColor: const Color.fromARGB(255, 123, 8, 29),
                  foregroundColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateTicket(
                              ticket: linkedTicket,
                              computer: widget.computer,
                            )));
                  },
                ),
              ]),
        ));
  }

  // Method to update and delete the selected computer
  Widget updateComputer() {
    final buttonForm = Button(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Form(
            key: _formKeyComputer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                formFieldsComputer.buildTextField(
                    _nameController,
                    Icons.title,
                    Translations.of(context)!.text('name'),
                    TextInputType.text,
                    true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: listUsers[selectedUserInCharge],
                        items: dropdown.dropdownItem(listUsersInCharge),
                        onChanged: (String? value) {
                          setState(() {
                            selectedUserInCharge = listUsers.keys.firstWhere((element) 
                              => listUsers[element] == value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText:
                              Translations.of(context)!.text('technician'),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: listUsers[selectedUser],
                        items: dropdown.dropdownItem(listUsers),
                        onChanged: (String? value) {
                          setState(() {
                            selectedUser = listUsers.keys.firstWhere((element) 
                              => listUsers[element] == value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('user'),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: listStatus[selectedStatus],
                        items: dropdown.dropdownItem(listStatus),
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = listStatus.keys.firstWhere((element) 
                              => listStatus[element] == value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('status'),
                          prefixIcon: const Icon(Icons.query_stats_sharp,
                              color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedUpdateSource,
                        items: dropdown.dropdownItem(listUpdateSource),
                        onChanged: (String? value) {
                          setState(() {
                            selectedUpdateSource = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('source'),
                          prefixIcon:
                              const Icon(Icons.source, color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: listLocations[selectedLocation],
                        items: dropdown.dropdownItem(listLocations),
                        onChanged: (String? value) {
                          setState(() {
                            selectedLocation = listLocations.keys.firstWhere((element) 
                              => listLocations[element] == value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('location'),
                          prefixIcon:
                              const Icon(Icons.house, color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: listEntities[selectedEntity],
                        items: dropdown.dropdownItem(listEntities),
                        onChanged: (String? value) {
                          setState(() {
                            selectedEntity = listEntities.keys.firstWhere((element) 
                              => listEntities[element] == value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('entity'),
                          prefixIcon: const Icon(
                              Icons.integration_instructions_outlined,
                              color: Colors.black),
                          focusColor: Colors.black,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          errorStyle: const TextStyle(
                              color: Color.fromARGB(255, 245, 183, 177),
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: formFieldsComputer.buildTextField(
                          _serialController,
                          Icons.numbers,
                          Translations.of(context)!.text('serial'),
                          TextInputType.text,
                          false),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: formFieldsComputer.buildTextField(
                          _otherSerialController,
                          Icons.numbers,
                          Translations.of(context)!.text('inventory'),
                          TextInputType.text,
                          false),
                    )
                  ],
                ),
                formFieldsComputer.buildTextAreaField(
                    _commentController,
                    Icons.text_fields,
                    Translations.of(context)!.text("comment"),
                    TextInputType.multiline,
                    false),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          child: buttonForm.buttonDelete(() async {
                            responseAPIDelete = objectComputer.apiMgmt.delete(
                                ApiEndpoint.apiRootComputer,
                                widget.computer.id!);

                            final apiResponseValueDelete =
                                await responseAPIDelete
                                    .then((val) => val["delete"]);

                            if (apiResponseValueDelete == "true") {
                              if (!mounted) return;
                              messages.messageBottomBar(
                                  Translations.of(context)!
                                      .text('item_deleted'),
                                  context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ComputersPage(),
                              ));
                            } else if (apiResponseValueDelete ==
                                "errorDelete") {
                              if (!mounted) return;
                              messages.sendAlert(
                                  Translations.of(context)!
                                      .text('error_delete'),
                                  context);
                            } else {
                              if (!mounted) return;
                              messages.sendAlert(
                                  Translations.of(context)!
                                      .text('delete_canceled'),
                                  context);
                            }
                          })),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: buttonForm.buttonSave(
                          () async {
                            if (!_formKeyComputer.currentState!.validate()) {
                              return;
                            } else {
                              var statusID = selectedStatus;

                              var entityID = selectedEntity;

                              var locationID = selectedLocation;

                              var updateSourceID = listUpdateSource.keys.where(
                                  (element) =>
                                      listUpdateSource[element] ==
                                      selectedUpdateSource);
                              var userTechID = selectedUserInCharge;
                              var userID = selectedUser;

                              updateData["name"] = _nameController.text;
                              updateData["states_id"] = statusID;
                              updateData["entities_id"] = entityID;
                              updateData["locations_id"] = locationID;
                              updateData["autoupdatesystems_id"] =
                                  updateSourceID.first;
                              updateData["users_id_tech"] = userTechID;
                              updateData["users_id"] = userID;

                              updateData["serial"] = _serialController.text;
                              updateData["otherserial"] =
                                  _otherSerialController.text;

                              updateData["comment"] = _commentController.text;

                              responseAPI = objectComputer.apiMgmt.put(
                                  ApiEndpoint.apiRootComputer,
                                  widget.computer.id!,
                                  updateData);

                              final apiResponseValue = await responseAPI
                                  .then((val) => val["update"]);

                              if (apiResponseValue == "true") {
                                if (!mounted) return;
                                messages.messageBottomBar(
                                    Translations.of(context)!
                                        .text('item_updated'),
                                    context);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ComputersPage(),
                                ));
                              } else if (apiResponseValue == "errorUpdate") {
                                if (!mounted) return;
                                messages.sendAlert(
                                    Translations.of(context)!
                                        .text('error_update'),
                                    context);
                              } else {
                                if (!mounted) return;
                                messages.sendAlert(
                                    Translations.of(context)!
                                        .text('update_canceled'),
                                    context);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  // Display all followup
  Widget displayAllItemsTickets() {
    return ListView(
      children: [
        Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: allItemsTickets.length,
                itemBuilder: _itemBuilderListTickets),
          ],
        )
      ],
    );
  }

  Widget _itemBuilderListTickets(BuildContext context, int index) {
    var ticketData = allTicketsWithComputer.where((element) =>
        element.id == allItemsTickets[index].ticketsID);

    if (allItemsTickets.asMap().containsKey(index) && allItemsTickets[index].itemsID ==
        widget.computer.id) {
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.error_outline,
                      size: 30,
                      color: Colors.black,
                    ),
                    horizontalTitleGap: 5,
                    title: Text(
                      //allItemsTickets[index].ticketsID.toString(),
                      allTicketsWithComputer.firstWhere((element) => element.id == allItemsTickets[index].ticketsID).title.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(
                      allItemsTickets[index].dateTicket.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      //allItemsTickets[index].statusTicket.toString(),
                      listTicketStatus[int.parse(allItemsTickets[index].statusTicket.toString())]!,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailTicket(ticket: ticketData.first)));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const InkWell(
        child: Text(""),
      );
    }
  }

  getAllStatus() async {
    // Object of the Special Status class
    final itemsTicket = StateComputer();
    List<StateComputer> allItemsTickets =
        await itemsTicket.getAllStateComputer();
    setState(() {
      listStatus[0] = "";
      for (var e in allItemsTickets) {
        listStatus[e.id!] = e.name.toString();
      }
    });
  }

  getAllEntities() async {
    // Object of the Special Status class
    final entities = Entity();
    List<Entity> allEntities = await entities.getAllEntities();
    setState(() {
      for (var e in allEntities) {
        listEntities[e.id!] = e.name.toString();
      }
    });
  }

  getAllLocations() async {
    // Object of the Special Status class
    final location = Location();
    List<Location> allLocations = await location.getAllLocations();
    setState(() {
      listLocations[0] = "";
      for (var e in allLocations) {
        listLocations[e.id!] = e.name.toString();
      }
    });
  }

  getAllUpdateSource() async {
    // Object of the Special Status class
    final source = UpdateSource();
    List<UpdateSource> allgetAllUpdateSource =
        await source.getAllUpdateSource();
    setState(() {
      listUpdateSource[0] = "";
      for (var e in allgetAllUpdateSource) {
        listUpdateSource[e.id!] = e.name.toString();
      }
    });
  }

  getAllUsers() async {
    // Object of the Special Status class
    final user = User();
    List<User> allUsers = await user.getAllUsers();
    setState(() {
      listUsers[0] = "";
      for (var e in allUsers) {
        listUsers[e.id!] = e.name.toString();
      }
    });
  }

  getAllUsersInCharge() async {
    // Object of the Special Status class
    final userTech = User();
    List<User> allUsers = await userTech.getAllUsers();
    setState(() {
      listUsersInCharge[0] = "";
      for (var e in allUsers) {
        listUsersInCharge[e.id!] = e.name.toString();
      }
    });
  }

  getAllItemsTickets() async {
    // Object of the Special Status class
    final itemsTickets = ItemTicket();
    List<ItemTicket> allItems = await itemsTickets.getAllItemTicket();

    final ticket = Tickets();
    var apires = ticket.apiMgmt.get(ApiEndpoint.apiGetAllTickets);
    List<Tickets> allTickets = await ticket.fetchTicketsData(apires);

    setState(() {
      for (var e in allItems) {
        for (Tickets ele in allTickets) {
          if (e.ticketsID == ele.id) {
            e.dateTicket = ele.date;
            e.statusTicket = ele.statusValue;
            //allTicketsWithComputer.add(ele);
          }
        }

        allItemsTickets.add(e);
      }
    });
  }

  getAllItemsTicketsByComputer() async {
    int? id = widget.computer.id;
    final itemsTickets = ItemTicket();
    final tickets = Tickets();

    var apiItemTicket = itemsTickets.apiMgmt.get(ApiEndpoint.apiGetItemTicketByComputer + id.toString());
    allItemsTickets = await itemsTickets.fetchItemTicketData(apiItemTicket);

    List<ItemTicket> deleted = [];

    for (ItemTicket it in allItemsTickets){
      var apiTicket = tickets.apiMgmt.get(ApiEndpoint.apiGetTicketsById + it.ticketsID.toString());
      Tickets ticket = await tickets.fetchItemTicketDataNoList(apiTicket);

      if (ticket.isDeleted == 0) {
        it.dateTicket = ticket.date;
        it.statusTicket = ticket.statusValue;
        allTicketsWithComputer.add(ticket);
      } else {
        deleted.add(it);
      }
    }

    for (ItemTicket it in deleted) {
      allItemsTickets.remove(it);
    }

  }

    getAllTicketStatus() async {
    // Object of the Special Status class
    final specialStatus = SpecialStatus();
    List<SpecialStatus> allSpecialStatus =
        await specialStatus.getAllSpecialStatus();
    setState(() {
      for (var e in allSpecialStatus) {
        listTicketStatus[e.id!] = e.name.toString();
      }
      //selectedStatus = listTicketStatus.values.first;
    });
  }
}
