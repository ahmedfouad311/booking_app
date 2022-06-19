// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class UserBookingData {
  static const String COLLECTION_NAME = 'User Booking Data';
  String id;
  String userId;
  String stadium;
  DateTime userDate;
  Map timeRange;

  UserBookingData({
    required this.id,
    required this.userId,
    required this.stadium,
    required this.userDate,
    required this.timeRange,
  });

  UserBookingData.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id']! as String,
            userId: json['userId']! as String,
            stadium: json['stadium']! as String,
            userDate: DateTime.fromMillisecondsSinceEpoch(
                json['userDate']! as int),
            timeRange: json['timeRange']! as Map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stadium': stadium,
      'userDate': userDate.millisecondsSinceEpoch,
      'timeRange': timeRange,
    };
  }
}
