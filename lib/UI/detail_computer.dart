import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobileapp/UI/computers_page.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/button.dart';
import 'package:mobileapp/common/dropdown.dart';
import 'package:mobileapp/common/form_fields.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/entity.dart';
import 'package:mobileapp/models/location.dart';
import 'package:mobileapp/models/state_computer.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:mobileapp/models/update_source.dart';
import 'package:mobileapp/models/user.dart';
import 'package:mobileapp/translations.dart';

class DetailComputer extends StatefulWidget {
  const DetailComputer({super.key, required this.computer});
  final Computer computer;

  @override
  State<DetailComputer> createState() => _DetailComputerState();
}

class _DetailComputerState extends State<DetailComputer> {
  final GlobalKey<FormState> _formKeyComputer = GlobalKey<FormState>();

  final formFieldsComputer = BuildFormFields();
  final buttonForm = Button();

  final objectComputer = Computer();
  dynamic responseAPI;
  dynamic responseAPIDelete;

  Map updateData = {};

  final messages = Messages();
  final dropdown = Dropdown();

  Map<int, String> listStatus = {};
  late String selectedStatus;

  Map<int, String> listEntities = {};
  late String selectedEntity;

  Map<int, String> listLocations = {};
  late String selectedLocation;

  Map<int, String> listUpdateSource = {};
  late String selectedUpdateSource;

  Map<int, String> listUsersInCharge = {};
  late String selectedUserInCharge;

  Map<int, String> listUsers = {};
  late String selectedUser;

  List<Tickets> allTickets = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _otherSerialController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.computer.name.toString();
    _serialController.text = widget.computer.serial.toString();
    _dateController.text = widget.computer.date.toString();
    _otherSerialController.text = widget.computer.otherSerial.toString();
    _commentController.text = widget.computer.comment.toString();

    selectedStatus = widget.computer.statusValue.toString();
    selectedEntity = widget.computer.entity.toString();
    selectedLocation = widget.computer.location.toString();
    selectedUpdateSource = widget.computer.source.toString();
    selectedUserInCharge = widget.computer.userIdTech.toString();
    selectedUser = widget.computer.userID.toString();

    getAllStatus();
    getAllEntities();
    getAllLocations();
    getAllUpdateSource();
    getAllUsersInCharge();
    getAllUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Translations.of(context)!.text('computer')),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 123, 8, 29),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
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
              listTickets(),
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
                  child: const Icon(Icons.follow_the_signs),
                  label: Translations.of(context)!.text('create_computer'),
                  backgroundColor: const Color.fromARGB(255, 123, 8, 29),
                  foregroundColor: Colors.white,
                  onTap: () {},
                ),
                SpeedDialChild(
                  child: const Icon(Icons.task),
                  label: Translations.of(context)!.text('create_ticket'),
                  backgroundColor: const Color.fromARGB(255, 123, 8, 29),
                  foregroundColor: Colors.white,
                  onTap: () {},
                ),
              ]),
        ));
  }

  // Method to update and delete the selected computer
  Widget updateComputer() {
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
                formFieldsComputer.buildTextField(_nameController, Icons.title,
                    Translations.of(context)!.text('name'), TextInputType.text),
                formFieldsComputer.buildDateTimeField(_dateController,
                    Translations.of(context)!.text('open_date'), context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedUserInCharge,
                        items: dropdown.dropdownItem(listUsersInCharge),
                        onChanged: (String? value) {
                          setState(() {
                            selectedUserInCharge = value!;
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
                        value: selectedUser,
                        items: dropdown.dropdownItem(listUsers),
                        onChanged: (String? value) {
                          setState(() {
                            selectedUser = value!;
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
                        value: selectedStatus,
                        items: dropdown.dropdownItem(listStatus),
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = value!;
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
                        value: selectedLocation,
                        items: dropdown.dropdownItem(listLocations),
                        onChanged: (String? value) {
                          setState(() {
                            selectedLocation = value!;
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
                        value: selectedEntity,
                        items: dropdown.dropdownItem(listEntities),
                        onChanged: (String? value) {
                          setState(() {
                            selectedEntity = value!;
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
                          TextInputType.text),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: formFieldsComputer.buildTextField(
                          _otherSerialController,
                          Icons.numbers,
                          Translations.of(context)!.text('inventory'),
                          TextInputType.text),
                    )
                  ],
                ),
                formFieldsComputer.buildTextAreaField(
                  _commentController,
                  Icons.text_fields,
                  "comment",
                  TextInputType.multiline,
                ),
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
                              var statusID = listStatus.keys.where((element) =>
                                  listStatus[element] == selectedStatus);

                              var entityID = listEntities.keys.where(
                                  (element) =>
                                      listEntities[element] == selectedEntity);

                              var locationID = listLocations.keys.where(
                                  (element) =>
                                      listLocations[element] ==
                                      selectedLocation);

                              var updateSourceID = listUpdateSource.keys.where(
                                  (element) =>
                                      listUpdateSource[element] ==
                                      selectedUpdateSource);
                              var userTechID = listUsersInCharge.keys.where(
                                  (element) =>
                                      listUsersInCharge[element] ==
                                      selectedUserInCharge);
                              var userID = listUsers.keys.where((element) =>
                                  listUsers[element] == selectedUser);

                              updateData["name"] = _nameController.text;
                              updateData["states_id"] = statusID.first;
                              updateData["entities_id"] = entityID.first;
                              updateData["locations_id"] = locationID.first;
                              updateData["autoupdatesystems_id"] =
                                  updateSourceID.first;
                              updateData["users_id_tech"] = userTechID.first;
                              updateData["users_id"] = userID.first;

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
  Widget listTickets() {
    return ListView(
      children: [
        Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: allTickets.length,
                itemBuilder: _itemBuilderListTickets),
          ],
        )
      ],
    );
  }

  Widget _itemBuilderListTickets(BuildContext context, int index) {
    return const Card();
  }

  getAllStatus() async {
    // Object of the Special Status class
    final specialStatus = StateComputer();
    List<StateComputer> allSpecialStatus =
        await specialStatus.getAllStateComputer();
    setState(() {
      for (var e in allSpecialStatus) {
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
}
