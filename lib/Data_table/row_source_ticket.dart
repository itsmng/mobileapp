import 'package:flutter/material.dart';

class RowSourceTicket extends DataTableSource {
  dynamic myData;
  final int count;
  RowSourceTicket({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentDataRow(myData![index]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.title ?? "Title")),
      DataCell(Text(data.category.toString())),
      DataCell(Text(data.location.toString())),
    ],
  );
}
