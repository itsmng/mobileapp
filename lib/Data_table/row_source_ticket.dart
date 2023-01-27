import 'package:flutter/material.dart';
import 'package:mobileapp/UI/detail_ticket.dart';
import 'package:mobileapp/models/tickets_model.dart';

/// Display all data of a table
class RowSourceTicket extends DataTableSource {
  dynamic myData;
  final int count;
  String customSecondHeader, customThirdHeader;
  BuildContext context;
  RowSourceTicket({
    required this.myData,
    required this.count,
    required this.customSecondHeader,
    required this.customThirdHeader,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentDataRow(
          myData![index], customSecondHeader, customThirdHeader, context);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

/// Display a row of a table
DataRow recentDataRow(Tickets data, String firstHeaderCustomizable,
    String secondHeaderCustomizable, BuildContext context) {
  return DataRow(
    cells: [
      DataCell(Text(data.title.toString()),
          // ignore: avoid_returning_null_for_void
          onTap: (() => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTicket(
                  ticket: data,
                ),
              )))),
      // Create dynamic values
      DataCell(
          Text(data.getAttribute(firstHeaderCustomizable, context).toString())),
      DataCell(Text(
          data.getAttribute(secondHeaderCustomizable, context).toString())),
    ],
  );
}
