import 'package:flutter/material.dart';

class StringFunctions {

  String getProjectQuery(List<String> filters) {
    debugPrint("filters= ${filters}");
    if(filters.length> 1) {
      return "?sort_by=${filters[0].toLowerCase()}&sort_order=${getOrderCode(filters[1])}";
    } else {
      return "?sort_by=${filters[0].toLowerCase()}&sort_order=asc";
    }
  }

  String getTaskQuery(List<String> filters) {
    debugPrint("filters= ${filters}");
    if(filters.length> 1) {
      return "?sort_by=${filters[0].toLowerCase()}&sort_order=${getOrderCode(filters[1])}";
    } else {
      return "?sort_by=${filters[0].toLowerCase()}&sort_order=asc";
    }
  }

  String getOrderCode(String orderTitle) {
    switch(orderTitle) {
      case "Ascending": return "asc";
      case "Descending": return "desc";
      default: return "asc";
    }
  }

  String getFormated(DateTime datetime) {
    String day= datetime.toString().split(" ").first;
    String hour= datetime.hour.toString().length==2? datetime.hour.toString() : "0${datetime.hour.toString()}";
    String minute= datetime.minute.toString().length==2? datetime.minute.toString() : "0${datetime.minute.toString()}";
    return "${day}T${hour}:${minute}:00Z";
  }
}