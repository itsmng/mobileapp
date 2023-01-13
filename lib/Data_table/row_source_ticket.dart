import 'package:flutter/material.dart';
import 'package:mobileapp/models/tickets_model.dart';

class RowSourceTicket extends DataTableSource {
  dynamic myData;
  final int count;
  String customSecondHeader, customThirdHeader;
  RowSourceTicket({
    required this.myData,
    required this.count,
    required this.customSecondHeader,
    required this.customThirdHeader,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentDataRow(myData![index], customSecondHeader, customThirdHeader);
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

DataRow recentDataRow(Tickets data, String firstHeaderCustomizable, String secondHeaderCustomizable) {

  return DataRow(
    cells: [
      DataCell(Text(data.title.toString())),
      // Create dynamic values  
      DataCell(Text(data.getAttribute(firstHeaderCustomizable).toString())),
      DataCell(Text(data.getAttribute(secondHeaderCustomizable).toString())),
    ],
  );
}
