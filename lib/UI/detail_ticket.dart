import 'package:flutter/material.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/dropdown.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/form_fields.dart/button.dart';
import 'package:mobileapp/form_fields.dart/form_fields_ticket.dart';
import 'package:mobileapp/models/entity.dart';
import 'package:mobileapp/models/itil_category.dart';
import 'package:mobileapp/models/location.dart';
import 'package:mobileapp/models/special_status.dart';
import 'package:mobileapp/models/ticket_user.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:mobileapp/models/user.dart';

class DetailTicket extends StatefulWidget {
  const DetailTicket({super.key, required this.ticket});
  final Tickets ticket;

  @override
  State<DetailTicket> createState() => _DetailTicketState();
}

class _DetailTicketState extends State<DetailTicket> {
  final GlobalKey<FormState> _formKeyTicket = GlobalKey<FormState>();

  final formFieldsTicket = FormFieldsTicket();
  final buttonForm = Button();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final objectTicket = Tickets();
  dynamic responseAPI;
  dynamic responseAPIUpdateUserAssigned;
  dynamic responseAPIDelete;
  Map updateData = {};
  Map updateTicketUserData = {};

  final messages = Messages();
  final dropdown = Dropdown();

  Map<int, String> listStatus = {};
  late String selectedStatus;

  Map<int, String> listEntities = {};
  late String selectedEntity;

  Map<int, String> listLocations = {};
  late String selectedLocation;

  Map<int, String> listITILCategory = {};
  late String selectedITILCategory;

  Map<int, String> listUsers = {};
  late String selectedUserRecipient;

  Map<int, String> listAssignedUsers = {};
  late String selectedAssignedUser;

  Map<int, String> listPriority = {
    1: "Very low",
    2: "Low",
    3: "Medium",
    4: "High",
    5: "Very high",
    6: "Major"
  };
  late String selectedPriority;

  List<DropdownMenuItem<String>> get dropdownPriority {
    List<DropdownMenuItem<String>> menuItem = [
      const DropdownMenuItem(value: "Very low", child: Text("Very low")),
      const DropdownMenuItem(value: "Low", child: Text("Low")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "High", child: Text("High")),
      const DropdownMenuItem(value: "Very high", child: Text("Very high")),
      const DropdownMenuItem(value: "Major", child: Text("Major")),
    ];
    return menuItem;
  }

  @override
  void initState() {
    _titleController.text = widget.ticket.title.toString();
    _contentController.text = widget.ticket.content.toString();
    _dateController.text = widget.ticket.date.toString();

    selectedPriority = widget.ticket.priority.toString();
    selectedStatus = widget.ticket.statusValue.toString();
    selectedEntity = widget.ticket.entity.toString();
    selectedLocation = widget.ticket.location.toString();
    selectedITILCategory = widget.ticket.category.toString();
    selectedUserRecipient = widget.ticket.recipient.toString();
    selectedAssignedUser = widget.ticket.assignedUser.toString();

    getAllStatus();
    getAllEntities();
    getAllLocations();
    getAllITILCategory();
    getAllUsers();
    getAllAssignedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ticket'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 123, 8, 29),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            bottom: const TabBar(
              labelStyle: TextStyle(color: Colors.white),
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Ticket'),
                Tab(text: 'Followup'),
                Tab(text: 'Task'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKeyTicket,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          formFieldsTicket.buildTextField(_titleController,
                              Icons.title, "Title", TextInputType.text),
                          formFieldsTicket.buildDateTimeField(
                              _dateController, "Open date", context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: selectedPriority,
                                  items: dropdownPriority,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedPriority = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Priority',
                                    prefixIcon: Icon(Icons.priority_high,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Entity',
                                    prefixIcon: Icon(Icons.category_sharp,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                    prefixIcon: Icon(Icons.query_stats_sharp,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Location',
                                    prefixIcon:
                                        Icon(Icons.house, color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: selectedITILCategory,
                                  items:
                                      dropdown.dropdownItem(listITILCategory),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedITILCategory = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    prefixIcon: Icon(
                                        Icons.integration_instructions_outlined,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
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
                                  value: selectedUserRecipient,
                                  items: dropdown.dropdownItem(listUsers),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedUserRecipient = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Recipient',
                                    prefixIcon: Icon(
                                        Icons.supervised_user_circle,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: selectedAssignedUser,
                                  items:
                                      dropdown.dropdownItem(listAssignedUsers),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedAssignedUser = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Assigned',
                                    prefixIcon: Icon(Icons.assignment_ind,
                                        color: Colors.black),
                                    focusColor: Colors.black,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.greenAccent),
                                    ),
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 183, 177),
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          formFieldsTicket.buildTextAreaField(
                            _contentController,
                            Icons.text_fields,
                            "Content",
                            TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: buttonForm.buttonDelete(() async {
                                  responseAPIDelete = objectTicket.apiMgmt
                                      .delete(ApiEndpoint.apiDeleteTicket,
                                          widget.ticket.id!);

                                  final apiResponseValueDelete =
                                      await responseAPIDelete
                                          .then((val) => val["delete"]);

                                  if (apiResponseValueDelete == "true") {
                                    if (!mounted) return;
                                    messages.messageBottomBar(
                                        "Item successfully deleted: ${widget.ticket.title}",
                                        context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const TicketsPage(),
                                    ));
                                  } else if (apiResponseValueDelete ==
                                      "errorDlete") {
                                    if (!mounted) return;
                                    messages.sendAlert(
                                        "Error to delete: Check API connexion",
                                        context);
                                  } else {
                                    if (!mounted) return;
                                    messages.sendAlert(
                                        "Deleted cancelled", context);
                                  }
                                }),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Expanded(child: buttonForm.buttonSave(
                                () async {
                                  if (!_formKeyTicket.currentState!
                                      .validate()) {
                                    return;
                                  } else {
                                    var priorityID = listPriority.keys.where(
                                        (element) =>
                                            listPriority[element] ==
                                            selectedPriority);

                                    var statusID = listStatus.keys.where(
                                        (element) =>
                                            listStatus[element] ==
                                            selectedStatus);

                                    var entityID = listEntities.keys.where(
                                        (element) =>
                                            listEntities[element] ==
                                            selectedEntity);

                                    var locationID = listLocations.keys.where(
                                        (element) =>
                                            listLocations[element] ==
                                            selectedLocation);

                                    var itilCategoryID = listITILCategory.keys
                                        .where((element) =>
                                            listITILCategory[element] ==
                                            selectedITILCategory);
                                    var userRecipientID = listUsers.keys.where(
                                        (element) =>
                                            listUsers[element] ==
                                            selectedUserRecipient);
                                    var assignedID = listUsers.keys.where(
                                        (element) =>
                                            listUsers[element] ==
                                            selectedAssignedUser);

                                    updateData["name"] = _titleController.text;
                                    updateData["priority"] = priorityID.first;
                                    updateData["status"] = statusID.first;
                                    updateData["entities_id"] = entityID.first;
                                    updateData["locations_id"] =
                                        locationID.first;
                                    updateData["itilcategories_id"] =
                                        itilCategoryID.first;
                                    updateData["users_id_recipient"] =
                                        userRecipientID.first;
                                    updateData["content"] =
                                        _contentController.text;

                                    updateTicketUserData["users_id"] =
                                        assignedID.first;

                                    responseAPIUpdateUserAssigned =
                                        objectTicket.apiMgmt.put(
                                            ApiEndpoint.apiUpdateTicketUser,
                                            widget.ticket.assignedUserID!,
                                            updateTicketUserData);

                                    responseAPI = objectTicket.apiMgmt.put(
                                        ApiEndpoint.apiUpdateTicket,
                                        widget.ticket.id!,
                                        updateData);

                                    final apiResponseValue = await responseAPI
                                        .then((val) => val["update"]);

                                    if (apiResponseValue == "true") {
                                      if (!mounted) return;
                                      messages.messageBottomBar(
                                          "Item successfully updated: ${widget.ticket.title}",
                                          context);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const TicketsPage(),
                                      ));
                                    } else if (apiResponseValue ==
                                        "errorUpdate") {
                                      if (!mounted) return;
                                      messages.sendAlert(
                                          "Error to update: Check API connexion",
                                          context);
                                    } else {
                                      if (!mounted) return;
                                      messages.sendAlert(
                                          "Update cancelled", context);
                                    }
                                  }
                                },
                              )),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              const Text('Follow up'),
              const Text('Task'),
            ],
          ),
        ));
  }

  getAllStatus() async {
    // Object of the Special Status class
    final specialStatus = SpecialStatus();
    List<SpecialStatus> allSpecialStatus =
        await specialStatus.getAllSpecialStatus();
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

  getAllITILCategory() async {
    // Object of the Special Status class
    final itilCategory = ITILCategory();
    List<ITILCategory> allITILCategories =
        await itilCategory.getAllItilCategories();
    setState(() {
      listITILCategory[0] = "";
      for (var e in allITILCategories) {
        listITILCategory[e.id!] = e.name.toString();
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

  getAllAssignedUsers() async {
    // Object of the Special Status class
    final assignedUser = TicketUser();
    List<TicketUser> allAssignedUsers = await assignedUser.getAllTicketUsers();
    await getAllUsers();
    setState(() {
      listAssignedUsers[0] = "";
      for (var e in allAssignedUsers) {
        if (!listAssignedUsers.containsValue(e.userID.toString())) {
          listUsers.forEach((key, value) {
            if (value == e.userID.toString()) {
              listAssignedUsers[key] = e.userID.toString();
            }
          });
        }
      }
    });
  }
}
