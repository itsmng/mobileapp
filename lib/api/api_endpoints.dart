class ApiEndpoint {
  // Current full session
  static const String apiGetFullSession = "getFullSession/";

  // Followup API Endpoint
  static const String apiRootTicketFollowup = "ITILFollowup/";
  static const String apiGetTicketFollowup =
      "ITILFollowup/?searchText[items_id]=";

  // Special status API Endpoint
  static const String apiGetAllSpecialStatus = "SpecialStatus";

  // Entity API Endpoint
  static const String apiGetAllEntities = "Entity";

  // Location API Endpoint
  static const String apiGetAllLocations = "Location";

  // ITIL category API Endpoint
  static const String apiGetAllItilCategories = "ITILCategory";

  // All User API Endpoint
  static const String apiGetAllUsers = "User";

  // State API Endpoint
  static const String apiGetAllStateComputer = "State";

  // Update source API Endpoint
  static const String apiGetRootUpdateSource = "Autoupdatesystem";

  // Items Ticket
  static const String apiRootItemTicket = "Item_Ticket";
  static const String apiGetItemTicketByComputer = 
      "Item_Ticket?searchText[itemtype]=Computer&searchText[items_id]=";

  // Ticket
  static const String apiRootTicket = "Ticket/?expand_dropdowns=true";
  static const String apiUpdateTicket = "Ticket/";
  static const String apiGetTicketsById = "Ticket/";
  static const String apiGetAllTickets =
      "Ticket/?range=0-40000";
  static const String apiGetMyTickets =
      "Ticket/?range=0-40000";
  static const String apiGetTicketsDetails = "Ticket/%s?expand_dropdowns=true";
  static const String apiDeleteTicket = "Ticket/";

  //Ticket User
  static const String apiUpdateTicketUser = "Ticket_User/";
  static const String apiGetAllTicketUsers =
      "Ticket_User/?searchText[type]=2";
  static const String apiGetTicketUsers =
      "Ticket_User/?searchText[tickets_id]=%s&searchText[type]=2";
  static const String apiGetTicketAssigned =
      "Ticket_User/?searchText[users_id]=%s&searchText[type]=2";

  // Computer 
  static const String apiGetAllComputers =
      "Computer/?range=0-40000";
  static const String apiGetAllComputersByName =
      "Computer/?searchText[name]=^%s&range=0-40000";
  static const String apiGetOneComputers = "Computer/%s?expand_dropdowns=true";
  static const String apiRootComputer = "Computer/";

  // Ticket Tasks
  static const String apiRootTicketTasks = "TicketTask/";
  static const String apiGetTicketTasks =
      "TicketTask/?searchText[tickets_id]=%s";
  static const String apiRootTicketTask = "TicketTask/";
  static const String apiGetTicketTask =
      "TicketTask/?searchText[tickets_id]=";
}
