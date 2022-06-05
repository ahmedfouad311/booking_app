// ignore_for_file: non_constant_identifier_names

class UserBookingData {
  static const String COLLECTION_NAME = 'User Booking Data';
  String id;
  String userId;
  String stadium;

  UserBookingData({
    required this.id,
    required this.userId,
    required this.stadium,
  });

  UserBookingData.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          userId: json['userId'] as String,
          stadium: json['stadium'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stadium': stadium,
    };
  }
}
