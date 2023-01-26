import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:mobileapp/models/update_source.dart';
import 'package:mobileapp/models/user.dart';
import 'package:mobileapp/translations.dart';

class CreateComputer extends StatefulWidget {
  const CreateComputer({super.key});

  @override
  State<CreateComputer> createState() => _CreateComputerState();
}

class _CreateComputerState extends State<CreateComputer> {
  final GlobalKey<FormState> _formKeyAddComputer = GlobalKey<FormState>();

  final formFieldsComputer = BuildFormFields();
  final buttonForm = Button();

  final objectComputer = Computer();
  dynamic responseAPIAddComputer;

  Map addComputerData = {};

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _otherSerialController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    _nameController.text = "";
    _serialController.text = "";
    _dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    _otherSerialController.text = "";
    _commentController.text = "";

    selectedStatus = "";
    selectedEntity = "";
    selectedLocation = "";
    selectedUpdateSource = "";
    selectedUserInCharge = "";
    selectedUser = "";

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
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.text('create_computer')),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 123, 8, 29),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(12),
        child: SingleChildScrollView(
            child: Form(
          key: _formKeyAddComputer,
          child: Column(
            children: <Widget>[
              formFieldsComputer.buildTextField(
                  _nameController,
                  Icons.title,
                  Translations.of(context)!.text('name'),
                  TextInputType.text,
                  true),
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
                        labelText: Translations.of(context)!.text('technician'),
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
              formFieldsComputer.buildTextAreaField(_commentController,
                  Icons.text_fields, "comment", TextInputType.multiline, false),
              const SizedBox(
                height: 20,
              ),
              buttonForm.buttonSave(
                () async {
                  if (!_formKeyAddComputer.currentState!.validate()) {
                    return;
                  } else {
                    var statusID = listStatus.keys.where(
                        (element) => listStatus[element] == selectedStatus);

                    var entityID = listEntities.keys.where(
                        (element) => listEntities[element] == selectedEntity);

                    var locationID = listLocations.keys.where((element) =>
                        listLocations[element] == selectedLocation);

                    var updateSourceID = listUpdateSource.keys.where(
                        (element) =>
                            listUpdateSource[element] == selectedUpdateSource);
                    var userTechID = listUsersInCharge.keys.where((element) =>
                        listUsersInCharge[element] == selectedUserInCharge);
                    var userID = listUsers.keys
                        .where((element) => listUsers[element] == selectedUser);

                    addComputerData["name"] = _nameController.text;
                    addComputerData["states_id"] = statusID.first;
                    addComputerData["entities_id"] = entityID.first;
                    addComputerData["locations_id"] = locationID.first;
                    addComputerData["autoupdatesystems_id"] =
                        updateSourceID.first;
                    addComputerData["users_id_tech"] = userTechID.first;
                    addComputerData["users_id"] = userID.first;

                    addComputerData["serial"] = _serialController.text;
                    addComputerData["otherserial"] =
                        _otherSerialController.text;

                    addComputerData["comment"] = _commentController.text;

                    responseAPIAddComputer = objectComputer.apiMgmt
                        .post(ApiEndpoint.apiRootComputer, addComputerData);

                    final apiResponseValue =
                        await responseAPIAddComputer.then((val) => val["add"]);

                    if (apiResponseValue == "true") {
                      if (!mounted) return;
                      messages.messageBottomBar(
                          Translations.of(context)!.text('item_added'),
                          context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ComputersPage(),
                      ));
                    } else if (apiResponseValue == "errorAdd") {
                      if (!mounted) return;
                      messages.sendAlert(
                          Translations.of(context)!.text('error_add'), context);
                    } else {
                      if (!mounted) return;
                      messages.sendAlert(
                          Translations.of(context)!.text('add_canceled'),
                          context);
                    }
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
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
      selectedStatus = listStatus.values.first;
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
      selectedEntity = listEntities.values.first;
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
      selectedLocation = listLocations.values.first;
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
      selectedUpdateSource = listUpdateSource.values.first;
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
      selectedUser = listUsers.values.first;
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
      selectedUserInCharge = listUsersInCharge.values.first;
    });
  }
}
