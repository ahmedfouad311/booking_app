// ignore_for_file: constant_identifier_names

import 'dart:developer';

class BookedData {
  static const String COLLECTION_NAME = 'Booked Data';
  String id;
  List<dynamic> bookedList;
  // String bookedStadium;
  // DateTime bookedDate;

  BookedData({
    required this.id,
    required this.bookedList,
    // required this.bookedStadium, required this.bookedDate
  });

  BookedData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String, bookedList: json['bookedList'] as List,
          // bookedStadium: json['bookedStadium'] as String, bookedDate: DateTime.fromMillisecondsSinceEpoch(
          //           json['bookedDate']! as int)
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'bookedList': bookedList,
      // 'bookedStadium': bookedStadium, 'bookedDate': bookedDate
    };
  }

  void update(List<dynamic> oldList) {
    dynamic value = bookedList[0];
    log(value.toString());
    bookedList = oldList;
    bookedList.add(value);
  }
}
