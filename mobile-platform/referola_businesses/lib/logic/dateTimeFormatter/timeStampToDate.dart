import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimestampConvertor{

  Map<int, String> dateMonthMapper = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
  };

  DateTime convertToDateTime(Timestamp timestamp){
    DateTime res = (DateTime.parse(timestamp.toDate().toString()));
    return res;
  }

  String organizeDate(DateTime dateTime){
    String day = dateTime.day < 10 ? "0"+dateTime.day.toString() : dateTime.day.toString();

    return (day+"-"+dateMonthMapper[dateTime.month]+"-"+dateTime.year.toString()).toString();

  }

  String organizeTimestamp(Timestamp timestamp){
    return organizeDate(convertToDateTime(timestamp));
  }

  String organizeTimeFromTimeStamp(Timestamp timestamp){
    DateTime dateTime = convertToDateTime(timestamp);
    String hours = dateTime.hour.toString();
    String mins = dateTime.minute.toString();

    if(dateTime.hour < 10){
      hours = "0"+hours;
    }
    if(dateTime.minute < 10){
      mins = "0" + mins;
    }

    return hours + ":"+ mins;
  }

  String organizeTimeOfTheDay(TimeOfDay time){
    String hours = time.hour.toString();
    String mins = time.minute.toString();

    if(time.hour < 10){
      hours = "0"+hours;
    }
    if(time.minute < 10){
      mins = "0" + mins;
    }

    return hours + ":"+ mins;
  }

}