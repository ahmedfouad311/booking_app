// ignore_for_file: constant_identifier_names

class BookingData {
  static const String COLLECTION_NAME = 'Booking';
  String id;
  String stadium;
  DateTime date;

  BookingData({required this.id, required this.stadium, required this.date});

  BookingData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          stadium: json['stadium'] as String,
          date: DateTime.fromMillisecondsSinceEpoch(json['date']! as int),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stadium': stadium,
      'date': date.millisecondsSinceEpoch,
    };
  }
}
