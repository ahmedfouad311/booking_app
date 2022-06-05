// ignore_for_file: non_constant_identifier_names

class UserBookingData{
  static const String COLLECTION_NAME = 'User Booking Data';
  String id;
  String userId;
  String match;
  String stadium;
  String date;

  UserBookingData({
    required this.id, required this.userId, required this.match, required this.stadium, required this.date
  });

  UserBookingData.fromJson(Map<String, dynamic> json):this(
    id: json['id'] as String,
    userId: json['userId'] as String,
    match: json['match'] as String,
    stadium: json['stadium'] as String,
    date: json['date'] as String,
  );

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'userId': userId,
      'match': match,
      'stadium': stadium,
      'date': date
    };
  }
}