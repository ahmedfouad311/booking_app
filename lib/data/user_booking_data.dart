// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class UserBookingData {
  static const String COLLECTION_NAME = 'User Booking Data';
  String id;
  String userId;
  String stadium;
  DateTime userFromDate;
  DateTime userToDate;

  UserBookingData({
    required this.id,
    required this.userId,
    required this.stadium,
    required this.userFromDate,
    required this.userToDate,
  });

  UserBookingData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          userId: json['userId'] as String,
          stadium: json['stadium'] as String,
          userFromDate:
              DateTime.fromMillisecondsSinceEpoch(json['userFromDate']! as int),
          userToDate:
              DateTime.fromMillisecondsSinceEpoch(json['userToDate']! as int),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stadium': stadium,
      'userFromDate': userFromDate.millisecondsSinceEpoch,
      'userToDate': userToDate.millisecondsSinceEpoch,
    };
  }
}
