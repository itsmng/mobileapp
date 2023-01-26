class ApiEndpoint {
  // Current full session
  static const String apiGetFullSession = "getFullSession/";

  // Ticket API Endpoint
  static const String apiRootTicket = "Ticket/?expand_dropdowns=true";
  static const String apiUpdateTicket = "Ticket/";
  static const String apiGetAllTickets =
      "Ticket/?expand_dropdowns=true&range=0-500";
  static const String apiGetMyTickets =
      "Ticket/?expand_dropdowns=true&range=0-500";
  static const String apiGetTicketsDetails = "Ticket/%s?expand_dropdowns=true";
  static const String apiDeleteTicket = "Ticket/";

  // Task API Endpoint
  static const String apiRootTicketTasks = "TicketTask/";
  static const String apiGetTicketTasks =
      "TicketTask/?expand_dropdowns=true&searchText[tickets_id]=%s";

  // Followup API Endpoint
  static const String apiRootTicketFollowup = "ITILFollowup/";
  static const String apiGetTicketFollowup =
      "ITILFollowup/?expand_dropdowns=true&searchText[items_id]=";

  // Task API Endpoint
  static const String apiRootTicketTask = "TicketTask/";
  static const String apiGetTicketTask =
      "TicketTask/?expand_dropdowns=true&searchText[tickets_id]=";

  // Ticket user Endpoint
  static const String apiGetTicketUsers =
      "Ticket_User/?expand_dropdowns=true&searchText[tickets_id]=%s&searchText[type]=2";
  static const String apiGetTicketAssigned =
      "Ticket_User/?expand_dropdowns=false&searchText[users_id]=%s&searchText[type]=2";

  // Computer API Endpoint
  static const String apiGetAllComputers =
      "Computer/?expand_dropdowns=true&range=0-500";
  static const String apiGetAllComputersByName =
      "Computer/?expand_dropdowns=true&searchText[name]=^%s&range=0-500";
  static const String apiGetOneComputers = "Computer/%s?expand_dropdowns=true";
  static const String apiRootComputer = "Computer/";

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

  // Ticket user API Endpoint
  static const String apiGetAllTicketUsers =
      "Ticket_User/?expand_dropdowns=true&searchText[type]=2";
  static const String apiUpdateTicketUser = "Ticket_User/";

  // State API Endpoint
  static const String apiGetAllStateComputer = "State";

  // Update source API Endpoint
  static const String apiGetRootUpdateSource = "Autoupdatesystem";

  // Item ticket API Endpoint
  static const String apiRootItemTicket = "Item_Ticket/?expand_dropdowns=true";
}
