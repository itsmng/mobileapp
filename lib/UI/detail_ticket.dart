import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobileapp/UI/tickets_page.dart';
import 'package:mobileapp/api/api_endpoints.dart';
import 'package:mobileapp/common/dropdown.dart';
import 'package:mobileapp/common/message.dart';
import 'package:mobileapp/common/button.dart';
import 'package:mobileapp/common/form_fields.dart';
import 'package:mobileapp/models/itil_category.dart';
import 'package:mobileapp/models/itil_followup.dart';
import 'package:mobileapp/models/location.dart';
import 'package:mobileapp/models/special_status.dart';
import 'package:mobileapp/models/task.dart';
import 'package:mobileapp/models/ticket_user.dart';
import 'package:mobileapp/models/tickets_model.dart';
import 'package:mobileapp/models/user.dart';
import 'package:mobileapp/translations.dart';

class DetailTicket extends StatefulWidget {
  const DetailTicket({super.key, required this.ticket});
  final Tickets ticket;

  @override
  State<DetailTicket> createState() => _DetailTicketState();
}

class _DetailTicketState extends State<DetailTicket> {
  final GlobalKey<FormState> _formKeyTicket = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyAlert = GlobalKey<FormState>();

  final formFieldsTicket = BuildFormFields();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentFollowupController =
      TextEditingController();
  final TextEditingController _contentTaskController = TextEditingController();
  bool isPrivateFollowup = false;
  bool isPrivateTask = false;

  final objectTicket = Tickets();
  dynamic responseAPI;
  dynamic responseAPIUpdateUserAssigned;
  dynamic responseAPIDelete;
  dynamic responseAPIAddFollowup;
  dynamic responseAPIAddTask;

  Map updateData = {};
  Map updateTicketUserData = {};
  Map addITILFollowupData = {};
  Map addTaskData = {};

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

  List<ITILfollowup> listITILFollowup = [];
  List<Task> listTask = [];

  bool isVisibleButton = false;

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
      DropdownMenuItem(
          value: "Very low",
          child: Text(Translations.of(context)!.text('priority_very_low'))),
      DropdownMenuItem(
          value: "Low",
          child: Text(Translations.of(context)!.text('priority_low'))),
      DropdownMenuItem(
          value: "Medium",
          child: Text(Translations.of(context)!.text('priority_medium'))),
      DropdownMenuItem(
          value: "High",
          child: Text(Translations.of(context)!.text('priority_high'))),
      DropdownMenuItem(
          value: "Very high",
          child: Text(Translations.of(context)!.text('priority_very_high'))),
      DropdownMenuItem(
          value: "Major",
          child: Text(Translations.of(context)!.text('priority_major'))),
    ];
    return menuItem;
  }

  Map<int, String> listToDo = {
    0: "Information",
    1: "To do",
    2: "Done",
  };
  late String selectedToDo;

  List<DropdownMenuItem<String>> get dropdownToDo {
    List<DropdownMenuItem<String>> menuItem = [
      const DropdownMenuItem(value: "Information", child: Text("Information")),
      DropdownMenuItem(
          value: "To do", child: Text(Translations.of(context)!.text('to_do'))),
      DropdownMenuItem(
          value: "Done", child: Text(Translations.of(context)!.text('done'))),
    ];
    return menuItem;
  }

  @override
  void initState() {
    _titleController.text = widget.ticket.title.toString();
    _contentController.text = widget.ticket.content.toString();
    _dateController.text = widget.ticket.date.toString();
    _contentFollowupController.clear();
    _contentTaskController.clear();

    selectedPriority = widget.ticket.priority.toString();
    selectedStatus = widget.ticket.statusValue.toString();
    selectedEntity = widget.ticket.entity.toString();
    selectedLocation = widget.ticket.location.toString();
    selectedITILCategory = widget.ticket.category.toString();
    selectedUserRecipient = widget.ticket.recipient.toString();
    selectedAssignedUser = widget.ticket.assignedUser.toString();
    selectedToDo = "To do";

    getAllStatus();
    getAllEntities();
    getAllLocations();
    getAllITILCategory();
    getAllUsers();
    getAllAssignedUsers();
    getAllITILFollowup();
    getAllTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(Translations.of(context)!.text('ticket')),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 123, 8, 29),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TicketsPage(),
                ));
              },
            ),
            bottom: TabBar(
              labelStyle: const TextStyle(color: Colors.white),
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(text: Translations.of(context)!.text('ticket')),
                Tab(text: Translations.of(context)!.text('followup')),
                Tab(text: Translations.of(context)!.text('task')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              updateTicket(),
              followup(),
              task(),
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
                  label: Translations.of(context)!.text('add_followup'),
                  backgroundColor: const Color.fromARGB(255, 123, 8, 29),
                  foregroundColor: Colors.white,
                  onTap: () {
                    showAddFollowup();
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.task),
                  label: Translations.of(context)!.text('add_task'),
                  backgroundColor: const Color.fromARGB(255, 123, 8, 29),
                  foregroundColor: Colors.white,
                  onTap: () {
                    showAddTaskForm();
                  },
                ),
              ]),
        ));
  }

  // Method to update and delete the selected ticket
  Widget updateTicket() {
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
            key: _formKeyTicket,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                        value: selectedPriority,
                        items: dropdownPriority,
                        onChanged: (String? value) {
                          setState(() {
                            selectedPriority = value!;
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
                        value: selectedITILCategory,
                        items: dropdown.dropdownItem(listITILCategory),
                        onChanged: (String? value) {
                          setState(() {
                            selectedITILCategory = value!;
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
                        decoration: InputDecoration(
                          labelText:
                              Translations.of(context)!.text('recipient'),
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
                formFieldsTicket.buildTextAreaField(
                    _contentController,
                    Icons.text_fields,
                    Translations.of(context)!.text("content"),
                    TextInputType.multiline,
                    true),
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
                            responseAPIDelete = objectTicket.apiMgmt.delete(
                                ApiEndpoint.apiDeleteTicket, widget.ticket.id!);

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
                                builder: (context) => const TicketsPage(),
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
                            if (!_formKeyTicket.currentState!.validate()) {
                              return;
                            } else {
                              var priorityID = listPriority.keys.where(
                                  (element) =>
                                      listPriority[element] ==
                                      selectedPriority);

                              var statusID = listStatus.keys.where((element) =>
                                  listStatus[element] == selectedStatus);

                              var entityID = listEntities.keys.where(
                                  (element) =>
                                      listEntities[element] == selectedEntity);

                              var locationID = listLocations.keys.where(
                                  (element) =>
                                      listLocations[element] ==
                                      selectedLocation);

                              var itilCategoryID = listITILCategory.keys.where(
                                  (element) =>
                                      listITILCategory[element] ==
                                      selectedITILCategory);
                              var userRecipientID = listUsers.keys.where(
                                  (element) =>
                                      listUsers[element] ==
                                      selectedUserRecipient);
                              var assignedID = listUsers.keys.where((element) =>
                                  listUsers[element] == selectedAssignedUser);

                              updateData["name"] = _titleController.text;
                              updateData["date"] = _dateController.text;
                              updateData["priority"] = priorityID.first;
                              updateData["status"] = statusID.first;
                              updateData["entities_id"] = entityID.first;
                              updateData["locations_id"] = locationID.first;
                              updateData["itilcategories_id"] =
                                  itilCategoryID.first;
                              updateData["users_id_recipient"] =
                                  userRecipientID.first;
                              updateData["content"] = _contentController.text;

                              updateTicketUserData["users_id"] =
                                  assignedID.first;
                              widget.ticket.assignedUserID ??= 0;

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
                                    Translations.of(context)!
                                        .text('item_updated'),
                                    context);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const TicketsPage(),
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
  Widget followup() {
    return ListView(
      children: [
        Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listITILFollowup.length,
                itemBuilder: _itemBuilderFollowup),
          ],
        )
      ],
    );
  }

  Widget _itemBuilderFollowup(BuildContext context, int index) {
    bool testIsPrivate = false;

    if (listITILFollowup[index].isPrivate.toString() == "1") {
      testIsPrivate = true;
    }

    if (listITILFollowup[index].itemsID.toString() ==
        widget.ticket.title.toString()) {
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
                      Icons.person,
                      size: 40,
                      color: Colors.black,
                    ),
                    trailing: Icon(
                      testIsPrivate ? Icons.lock : null,
                      size: 30,
                      color: const Color.fromARGB(255, 123, 8, 29),
                    ),
                    horizontalTitleGap: 5,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          listITILFollowup[index].userID.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          listITILFollowup[index].date.toString().split(" ")[0],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      listITILFollowup[index].content.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      showUpdateFollowup(
                          listITILFollowup[index].id!,
                          listITILFollowup[index].content.toString(),
                          listITILFollowup[index].isPrivate!);
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

  // Display all followup
  Widget task() {
    return ListView(
      children: [
        Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listTask.length,
                itemBuilder: _itemBuilderTask),
          ],
        )
      ],
    );
  }

  Widget _itemBuilderTask(BuildContext context, int index) {
    bool testIsPrivate = false;
    bool testDurationExist = false;
    IconData iconState;
    if (listTask[index].isPrivate.toString() == "1") {
      testIsPrivate = true;
    }
    if (listTask[index].fullDuration.toString() != "") {
      testDurationExist = true;
    }
    if (listTask[index].state == 0) {
      iconState = Icons.info;
    } else if (listTask[index].state == 1) {
      iconState = Icons.task;
    } else {
      iconState = Icons.done;
    }

    if (listTask[index].ticketID.toString() == widget.ticket.title.toString()) {
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
                      Icons.person,
                      size: 40,
                      color: Colors.black,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          testIsPrivate ? Icons.lock : null,
                          size: 20,
                          color: const Color.fromARGB(255, 123, 8, 29),
                        ),
                        Icon(
                          iconState,
                          size: 20,
                          color: const Color.fromARGB(255, 123, 8, 29),
                        )
                      ],
                    ),
                    horizontalTitleGap: 5,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Text(
                          listTask[index].userID.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text(
                          listTask[index].date.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          testDurationExist ? Icons.timer : null,
                          size: 15,
                          color: const Color.fromARGB(255, 123, 8, 29),
                        ),
                        Text(
                          listTask[index].fullDuration.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      listTask[index].content.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      showUpdateTask(
                        listTask[index].id!,
                        listTask[index].content.toString(),
                        listTask[index].isPrivate!,
                        listTask[index].state!,
                        listTask[index].stateVlaue!,
                        listTask[index].duration!,
                      );
                    },
                  ),
                )
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

  showUpdateFollowup(int idFollowup, String content, int privacy) {
    final buttonForm = Button(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController updateContentController =
              TextEditingController();
          bool updateIsPrivateFollowup = false;

          updateContentController.text = content;
          if (privacy == 1) {
            updateIsPrivateFollowup = true;
          } else {
            updateIsPrivateFollowup = false;
          }

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text(Translations.of(context)!.text('update_followup')),
              content: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      formFieldsTicket.buildTextAreaField(
                          updateContentController,
                          Icons.text_fields,
                          Translations.of(context)!.text('content'),
                          TextInputType.multiline,
                          true),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              Text(Translations.of(context)!.text('private')),
                            ],
                          ),
                          Switch(
                              value: updateIsPrivateFollowup,
                              onChanged: (bool? checked) {
                                setState(() {
                                  updateIsPrivateFollowup = checked!;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonForm.buttonExit(() {
                        Navigator.of(context).pop();
                      }),
                      buttonForm.buttonSave(() async {
                        Map<dynamic, dynamic> updateFollowupData = {};
                        updateFollowupData["content"] =
                            updateContentController.text;
                        updateFollowupData["is_private"] =
                            updateIsPrivateFollowup;

                        dynamic response = objectTicket.apiMgmt.put(
                            ApiEndpoint.apiRootTicketFollowup,
                            idFollowup,
                            updateFollowupData);

                        final responseValue =
                            await response.then((val) => val["update"]);

                        if (responseValue == "true") {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              Translations.of(context)!.text('item_updated'),
                              context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TicketsPage(),
                          ));
                        } else if (responseValue == "errorUpdate") {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('error_update'),
                              context);
                        } else {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('update_canceled'),
                              context);
                        }
                      }),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  showUpdateTask(int idTask, String content, int privacy, int state,
      String stateVlaue, int actionTime) {
    Duration duration = Duration(seconds: actionTime);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController updateTaskContentController =
              TextEditingController();
          bool updateIsPrivateTask = false;

          String seletedToDoVlaue = stateVlaue;
          updateTaskContentController.text = content;
          if (privacy == 1) {
            updateIsPrivateTask = true;
          } else {
            updateIsPrivateTask = false;
          }

          return StatefulBuilder(builder: (context, setState) {
            final buttonForm = Button(context);
            return AlertDialog(
              scrollable: true,
              title: Text(Translations.of(context)!.text('update_task')),
              content: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      formFieldsTicket.buildTextAreaField(
                          updateTaskContentController,
                          Icons.text_fields,
                          Translations.of(context)!.text('content'),
                          TextInputType.multiline,
                          true),
                      DropdownButtonFormField(
                        value: seletedToDoVlaue,
                        items: dropdownToDo,
                        onChanged: (String? value) {
                          setState(() {
                            seletedToDoVlaue = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('to_do'),
                          prefixIcon:
                              const Icon(Icons.add_task, color: Colors.black),
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
                      DurationPicker(
                        duration: duration,
                        baseUnit: BaseUnit.minute,
                        onChange: (val) {
                          setState(() => duration = val);
                        },
                        snapToMins: 15.0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              Text(Translations.of(context)!.text('private')),
                            ],
                          ),
                          Switch(
                              value: updateIsPrivateTask,
                              onChanged: (bool? checked) {
                                setState(() {
                                  updateIsPrivateTask = checked!;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonForm.buttonExit(() {
                        Navigator.of(context).pop();
                      }),
                      buttonForm.buttonSave(() async {
                        Map<dynamic, dynamic> updateTaskData = {};
                        updateTaskData["content"] =
                            updateTaskContentController.text;
                        updateTaskData["is_private"] = updateIsPrivateTask;

                        var stateID = listToDo.keys.where(
                            (element) => listToDo[element] == seletedToDoVlaue);
                        updateTaskData["state"] = stateID.first;
                        updateTaskData["actiontime"] = duration.inSeconds;

                        dynamic response = objectTicket.apiMgmt.put(
                            ApiEndpoint.apiRootTicketTask,
                            idTask,
                            updateTaskData);

                        final responseValue =
                            await response.then((val) => val["update"]);

                        if (responseValue == "true") {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              "Item successfully updated", context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TicketsPage(),
                          ));
                        } else if (responseValue == "errorUpdate") {
                          if (!mounted) return;
                          messages.sendAlert(
                              "Error to update: Check API connexion", context);
                        } else {
                          if (!mounted) return;
                          messages.sendAlert("Update cancelled", context);
                        }
                      }),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  showAddFollowup() {
    final buttonForm = Button(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          isPrivateFollowup = false;
          _contentFollowupController.clear();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text(Translations.of(context)!.text('add_followup')),
              content: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Form(
                  key: formKeyAlert,
                  child: Column(
                    children: <Widget>[
                      formFieldsTicket.buildTextAreaField(
                          _contentFollowupController,
                          Icons.text_fields,
                          Translations.of(context)!.text('content'),
                          TextInputType.multiline,
                          true),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              Text(Translations.of(context)!.text('private')),
                            ],
                          ),
                          Switch(
                              value: isPrivateFollowup,
                              onChanged: (bool? checked) {
                                setState(() {
                                  isPrivateFollowup = checked!;
                                });
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonForm.buttonExit(() {
                        Navigator.of(context).pop();
                      }),
                      buttonForm.buttonSave(() async {
                        addITILFollowupData["itemtype"] = "Ticket";
                        addITILFollowupData["items_id"] =
                            widget.ticket.id.toString();
                        addITILFollowupData["content"] =
                            _contentFollowupController.text;
                        if (isPrivateFollowup) {
                          addITILFollowupData["is_private"] = 1;
                        } else {
                          addITILFollowupData["is_private"] = 0;
                        }

                        responseAPIAddFollowup = objectTicket.apiMgmt.post(
                            ApiEndpoint.apiRootTicketFollowup,
                            addITILFollowupData);

                        final apiResponseAddFollowup =
                            await responseAPIAddFollowup
                                .then((val) => val["add"]);

                        if (apiResponseAddFollowup == "true") {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              Translations.of(context)!.text('item_added'),
                              context);
                           var ticket = Tickets(
                              id: widget.ticket.id,
                              date: _dateController.text,
                              statusValue: selectedStatus,
                              title: _titleController.text,
                              entity: selectedEntity,
                              priority: selectedPriority,
                              location: selectedLocation,
                              category: selectedITILCategory,
                              recipient: selectedUserRecipient,
                              assignedUser: selectedAssignedUser,
                              content: _contentController.text);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailTicket(
                              ticket: ticket,
                            ),
                          ));
                        } else if (apiResponseAddFollowup == "errorAdd") {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('error_add'),
                              context);
                        } else {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('add_canceled'),
                              context);
                        }
                      }),
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  showAddTaskForm() {
    final buttonForm = Button(context);
    Duration duration =
        const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          isPrivateTask = false;
          _contentTaskController.clear();
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text(Translations.of(context)!.text('add_task')),
              content: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Form(
                  key: formKeyAlert,
                  child: Column(
                    children: <Widget>[
                      formFieldsTicket.buildTextAreaField(
                          _contentTaskController,
                          Icons.text_fields,
                          Translations.of(context)!.text('content'),
                          TextInputType.multiline,
                          true),
                      DropdownButtonFormField(
                        value: selectedToDo,
                        items: dropdownToDo,
                        onChanged: (String? value) {
                          setState(() {
                            selectedToDo = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: Translations.of(context)!.text('to_do'),
                          prefixIcon:
                              const Icon(Icons.add_task, color: Colors.black),
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
                      DurationPicker(
                        duration: duration,
                        baseUnit: BaseUnit.minute,
                        onChange: (val) {
                          setState(() => duration = val);
                        },
                        snapToMins: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              Text(Translations.of(context)!.text('private')),
                            ],
                          ),
                          Switch(
                              value: isPrivateTask,
                              onChanged: (bool? checked) {
                                setState(() {
                                  isPrivateTask = checked!;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonForm.buttonExit(() {
                        Navigator.of(context).pop();
                      }),
                      buttonForm.buttonSave(() async {
                        addTaskData["tickets_id"] = widget.ticket.id.toString();
                        addTaskData["content"] = _contentTaskController.text;
                        if (isPrivateTask) {
                          addTaskData["is_private"] = 1;
                        } else {
                          addTaskData["is_private"] = 0;
                        }
                        addTaskData["state"] = selectedToDo;
                        addTaskData["actiontime"] = duration.inSeconds;

                        responseAPIAddTask = objectTicket.apiMgmt
                            .post(ApiEndpoint.apiRootTicketTask, addTaskData);

                        final apiResponseAddTask =
                            await responseAPIAddTask.then((val) => val["add"]);

                        if (apiResponseAddTask == "true") {
                          if (!mounted) return;
                          messages.messageBottomBar(
                              Translations.of(context)!.text('item_added'),
                              context);
                          var ticket = Tickets(
                              id: widget.ticket.id,
                              date: _dateController.text,
                              statusValue: selectedStatus,
                              title: _titleController.text,
                              entity: selectedEntity,
                              priority: selectedPriority,
                              location: selectedLocation,
                              category: selectedITILCategory,
                              recipient: selectedUserRecipient,
                              assignedUser: selectedAssignedUser,
                              content: _contentController.text);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailTicket(
                              ticket: ticket,
                            ),
                          ));
                        } else if (apiResponseAddTask == "errorAdd") {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('error_add'),
                              context);
                        } else {
                          if (!mounted) return;
                          messages.sendAlert(
                              Translations.of(context)!.text('add_canceled'),
                              context);
                        }
                      }),
                    ],
                  ),
                ),
              ],
            );
          });
        });
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
    setState(() {
      listEntities[1] = selectedEntity;
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

  getAllITILFollowup() async {
    // Object of the Special Status class
    final itilFollowup = ITILfollowup();

    List<ITILfollowup> allITILfollowup =
        await itilFollowup.getAllITILfollowup(widget.ticket.id!);

    setState(() {
      for (var e in allITILfollowup) {
        listITILFollowup.add(e);
      }
    });
  }

  getAllTask() async {
    // Object of the Special Status class
    final task = Task();

    List<Task> allTask = await task.getAllTask(widget.ticket.id!);

    setState(() {
      for (var ele in allTask) {
        listTask.add(ele);
      }
    });
  }
}
