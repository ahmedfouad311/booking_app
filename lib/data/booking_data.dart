// ignore_for_file: constant_identifier_names

class BookingData {
  static const String COLLECTION_NAME = 'Booking';
  String id;
  String stadium;
  DateTime fromDate;
  DateTime toDate;
  int hours;
  List timeRange;

  BookingData(
      {required this.id,
      required this.stadium,
      required this.fromDate,
      required this.toDate,
      required this.hours,
      required this.timeRange});

  BookingData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          stadium: json['stadium'] as String,
          fromDate:
              DateTime.fromMillisecondsSinceEpoch(json['fromDate']! as int),
          toDate: DateTime.fromMillisecondsSinceEpoch(json['toDate']! as int),
          hours: json['hours'] as int,
          timeRange: json['timeRange'] as List,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stadium': stadium,
      'fromDate': fromDate.millisecondsSinceEpoch,
      'toDate': toDate.millisecondsSinceEpoch,
      'hours': hours,
      'timeRange': timeRange,
    };
  }
}
