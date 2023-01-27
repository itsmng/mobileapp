import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/UI/computers_page.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/dropdown.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/common/button.dart';
import 'package:mobileapp/common/form_fields.dart';
import 'package:mobileapp/models/computer_model.dart';
import 'package:mobileapp/models/entity.dart';
import 'package:mobileapp/models/item_ticket.dart';
import 'package:mobileapp/models/itil_category.dart';
import 'package:mobileapp/models/location.dart';
import 'package:mobileapp/models/special_status.dart';
import 'package:mobileapp/models/ticket_user.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:mobileapp/models/user.dart';
import 'package:mobileapp/translations.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key, required this.ticket});
  final Tickets ticket;

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final GlobalKey<FormState> _formKeyTicket = GlobalKey<FormState>();

  final formFieldsTicket = BuildFormFields();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final objectTicket = Tickets();
  final objectItemsTicket = ItemTicket();
  dynamic responseAPIAddTicket;
  dynamic responseAPIAddUserAssigned;
  Map addTicketData = {};
  Map addTicketUserData = {};
  dynamic responseAPIAddItemsTicket;
  Map addItemsTicketData = {};

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

  Map<int, String> listComputer = {};
  late String? selectedComputer;

  @override
  void initState() {
    _titleController.text = "";
    _contentController.text = "";
    _dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    selectedPriority = "Medium";
    selectedStatus = "";
    selectedEntity = "";
    selectedLocation = "";
    selectedITILCategory = "";
    selectedUserRecipient = "";
    selectedAssignedUser = "";
    selectedComputer = widget.ticket.associatedElement;

    getAllStatus();
    getAllEntities();
    getAllLocations();
    getAllITILCategory();
    getAllUsers();
    getAllAssignedUsers();
    getAllItemsTicket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonForm = Button(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context)!.text('create_ticket')),
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
          key: _formKeyTicket,
          child: Column(
            children: <Widget>[
              formFieldsTicket.buildTextField(
                  _titleController,
                  Icons.title,
                  Translations.of(context)!.text('title'),
                  TextInputType.text,
                  true),
              formFieldsTicket.buildDateTimeField(_dateController,
                  Translations.of(context)!.text('open_date'), context),
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
                      onSaved: (String? val) {
                        setState(() {
                          selectedStatus = val!;
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
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedPriority,
                      items: dropdownPriority,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                      onSaved: (String? val) {
                        setState(() {
                          selectedPriority = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!.text('priority'),
                        prefixIcon: const Icon(Icons.priority_high,
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
                      value: selectedEntity,
                      items: dropdown.dropdownItem(listEntities),
                      onChanged: (String? value) {
                        setState(() {
                          selectedEntity = value!;
                        });
                      },
                      onSaved: (String? val) {
                        setState(() {
                          selectedEntity = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!.text('entity'),
                        prefixIcon: const Icon(Icons.category_sharp,
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
                      onSaved: (String? val) {
                        setState(() {
                          selectedLocation = val!;
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
                      value: selectedITILCategory,
                      items: dropdown.dropdownItem(listITILCategory),
                      onChanged: (String? value) {
                        setState(() {
                          selectedITILCategory = value!;
                        });
                      },
                      onSaved: (String? val) {
                        setState(() {
                          selectedITILCategory = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!.text('category'),
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
                      onSaved: (String? val) {
                        setState(() {
                          selectedUserRecipient = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!.text('recipient'),
                        prefixIcon: const Icon(Icons.supervised_user_circle,
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
                      value: selectedAssignedUser,
                      items: dropdown.dropdownItem(listAssignedUsers),
                      onChanged: (String? value) {
                        setState(() {
                          selectedAssignedUser = value!;
                        });
                      },
                      onSaved: (String? val) {
                        setState(() {
                          selectedAssignedUser = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!.text('assigned'),
                        prefixIcon: const Icon(Icons.assignment_ind,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedComputer,
                      items: dropdown.dropdownItem(listComputer),
                      onChanged: (String? value) {
                        setState(() {
                          selectedComputer = value!;
                        });
                      },
                      onSaved: (String? val) {
                        setState(() {
                          selectedComputer = val!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: Translations.of(context)!
                            .text('associated_element'),
                        prefixIcon: const Icon(Icons.dataset_linked,
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
              const SizedBox(
                height: 20,
              ),
              formFieldsTicket.buildTextAreaField(
                  _contentController,
                  Icons.text_fields,
                  Translations.of(context)!.text('content'),
                  TextInputType.multiline,
                  true),
              const SizedBox(
                height: 50,
              ),
              buttonForm.buttonSave(
                () async {
                  if (!_formKeyTicket.currentState!.validate()) {
                    return;
                  } else {
                    var priorityID = listPriority.keys.where(
                        (element) => listPriority[element] == selectedPriority);

                    var statusID = listStatus.keys.where(
                        (element) => listStatus[element] == selectedStatus);

                    var entityID = listEntities.keys.where(
                        (element) => listEntities[element] == selectedEntity);

                    var locationID = listLocations.keys.where((element) =>
                        listLocations[element] == selectedLocation);

                    var itilCategoryID = listITILCategory.keys.where(
                        (element) =>
                            listITILCategory[element] == selectedITILCategory);
                    var userRecipientID = listUsers.keys.where((element) =>
                        listUsers[element] == selectedUserRecipient);
                    var associatedElementID = listComputer.keys.where(
                        (element) => listComputer[element] == selectedComputer);
                    /*
                    var assignedID = listUsers.keys.where((element) =>
                        listUsers[element] == selectedAssignedUser);
                  */

                    addTicketData["name"] = _titleController.text;
                    addTicketData["priority"] = priorityID.first;
                    addTicketData["status"] = statusID.first;
                    addTicketData["entities_id"] = entityID.first;
                    addTicketData["locations_id"] = locationID.first;
                    addTicketData["itilcategories_id"] = itilCategoryID.first;
                    addTicketData["users_id_recipient"] = userRecipientID.first;
                    addTicketData["content"] = _contentController.text;

                    responseAPIAddTicket = objectTicket.apiMgmt
                        .post(ApiEndpoint.apiUpdateTicket, addTicketData);

                    final apiResponseValue =
                        await responseAPIAddTicket.then((val) => val["add"]);

                    if (apiResponseValue == "true") {
                      if (associatedElementID.isNotEmpty) {
                        // Get the Id of the new ticket
                        final getIDValue =
                            await responseAPIAddTicket.then((val) => val["id"]);
                        addItemsTicketData["items_id"] =
                            associatedElementID.first;
                        addItemsTicketData["itemtype"] = "Computer";
                        addItemsTicketData["tickets_id"] = getIDValue;
                        objectItemsTicket.apiMgmt.post(
                            ApiEndpoint.apiRootItemTicket, addItemsTicketData);
                        if (widget.ticket.associatedElement != null) {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              Translations.of(context)!.text('item_added'),
                              context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ComputersPage()));
                        }
                      } else {
                        if (!mounted) return;
                        messages.messageBottomBar(
                            Translations.of(context)!.text('item_added'),
                            context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TicketsPage(),
                        ));
                      }
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
    final specialStatus = SpecialStatus();
    List<SpecialStatus> allSpecialStatus =
        await specialStatus.getAllSpecialStatus();
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
      selectedITILCategory = listITILCategory.values.first;
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
      selectedUserRecipient = listUsers[0].toString();
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
      selectedAssignedUser = listAssignedUsers[0].toString();
    });
  }

  getAllItemsTicket() async {
    // Object of the Special Status class
    final computer = Computer();
    dynamic apiResponseComputer =
        computer.apiMgmt.get(ApiEndpoint.apiGetAllComputers);
    List<Computer> futureComputer =
        await computer.fetchComputerData(apiResponseComputer);

    setState(() {
      listComputer[0] = "";
      for (var e in futureComputer) {
        listComputer[e.id!] = e.name.toString();
      }
    });
  }
}
