// ignore_for_file: constant_identifier_names

class BookingData {
  static const String COLLECTION_NAME = 'Booking';
  String id;
  String match;
  String stadium;
  String date;

  BookingData(
      {required this.id,
      required this.match,
      required this.stadium,
      required this.date});

  BookingData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          match: json['match'] as String,
          stadium: json['stadium'] as String,
          date: json['date'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match': match,
      'stadium': stadium,
      'date': date,
    };
  }
}
