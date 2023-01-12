class ApiEndpoint {
  // Current full session
  static const String apiGetFullSession = "getFullSession/";

  // Ticket API Endpoint
  static const String apiRootTicket = "Ticket/";
  static const String apiUpdateTicket = "Ticket/%s";
  static const String apiGetAllTickets =
      "Ticket/?expand_dropdowns=true&range=0-500";
  static const String apiGetMyTickets =
      "Ticket/?expand_dropdowns=true&range=0-500";
  static const String apiGetTicketsDetails = "Ticket/%s?expand_dropdowns=true";

  // Task API Endpoint
  static const String apiRootTicketTasks = "TicketTask/";
  static const String apiGetTicketTasks =
      "TicketTask/?expand_dropdowns=true&searchText[tickets_id]=%s";

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

  // Special status API Endpoint
  static const String apiGetAllSpecialStatus = "SpecialStatus";
}
