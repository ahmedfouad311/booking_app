import 'dart:developer';

import 'package:booking_app/data/booked_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<BookingData> getBookingCollectionWithConverter() {
  return FirebaseFirestore.instance
      .collection(BookingData.COLLECTION_NAME)
      .withConverter<BookingData>(
          fromFirestore: (snapshot, _) =>
              BookingData.fromJson(snapshot.data()!),
          toFirestore: (item, _) => item.toJson());
}

CollectionReference<UserData> getUserCollectionwithConverter() {
  return FirebaseFirestore.instance
      .collection(UserData.COLLECTION_NAME)
      .withConverter<UserData>(
        fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
        toFirestore: (fireBaseUser, _) => fireBaseUser.toJson(),
      );
}

CollectionReference<UserBookingData> getUserBookingCollectionWithConverter() {
  return FirebaseFirestore.instance
      .collection(UserBookingData.COLLECTION_NAME)
      .withConverter(
          fromFirestore: (snapshot, _) =>
              UserBookingData.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson());
}

CollectionReference<BookedData> getBookedDataCollectionWithConverter() {
  return FirebaseFirestore.instance
      .collection(BookedData.COLLECTION_NAME)
      .withConverter(
        fromFirestore: (snapshot, _) => BookedData.fromJson(snapshot.data()!),
        toFirestore: (data, _) => data.toJson(),
      );
}

Future<void> addBookingToFirestore(String stadium, DateTime fromDate,
    DateTime toDate, int hours, List<Map<dynamic, dynamic>> timeRange) {
  CollectionReference<BookingData> collectionReference =
      getBookingCollectionWithConverter();

  DocumentReference<BookingData> documentReference =
      collectionReference.doc(); // to create new object with new id

  BookingData data = BookingData(
      id: documentReference.id,
      stadium: stadium,
      fromDate: fromDate,
      toDate: toDate,
      hours: hours,
      timeRange: timeRange);

  return documentReference.set(data);
}

Future<void> addUserTOFireStore(UserData user) {
  return getUserCollectionwithConverter()
      .doc(user.id)
      .set(user); // ba3ml create le doc gdeda
}

Future<UserData?> getUserByID(String userId) async {
  DocumentSnapshot<UserData> result =
      await getUserCollectionwithConverter().doc(userId).get();
  return result.data();
}

Future<void> addUserBookingToFirebase(UserBookingData userBookingData) {
  CollectionReference<UserBookingData> collectionReference =
      getUserBookingCollectionWithConverter();

  DocumentReference<UserBookingData> documentReference =
      collectionReference.doc(); // to create new object with new id

  UserBookingData data = userBookingData;

  return documentReference.set(data);
}

Future<void> deleteBookingData(List list) {
  CollectionReference<BookingData> collectionReference =
      getBookingCollectionWithConverter();

  DocumentReference documentReference = collectionReference.doc('id');
  return documentReference.update({'timeRange': FieldValue.arrayRemove(list)});
}

Future<void> addBookedDataToFirebase(
    BookedData bookedData, DateTime userDate) async {
  CollectionReference<BookedData> collectionReference =
      getBookedDataCollectionWithConverter();

  DocumentReference<BookedData> documentReference =
      collectionReference.doc("booked");

  QuerySnapshot querySnapshot = await collectionReference.get();
  try {
    final oldData =
        querySnapshot.docs.map((doc) => doc.get('bookedList')).toList();

    bookedData.update(oldData[0]);
    BookedData data = bookedData;
    return documentReference.set(data);
  } catch (error) {
    BookedData data = bookedData;
    return documentReference.set(data);
  }
}

// Future<void> getBookedDataFromFirebase(
//     List<String> list, DateTime userDate) async {
//   CollectionReference<BookedData> collectionReference =
//       getBookedDataCollectionWithConverter();

//   DocumentReference<BookedData> documentReference =
//       collectionReference.doc('booked');

//   QuerySnapshot querySnapshot = await collectionReference.get();
//   final oldData =
//       querySnapshot.docs.map((doc) => doc.get('bookedList')).toList();
//   try {
//     for (dynamic itemBooked in oldData[0]) {
//       String word = itemBooked;
//       list.remove(word);
//     }
//   } catch (error) {}
// }

// Future<void> updateBooking(BookingData bookingData) {
//   CollectionReference<BookingData> collectionReference =
//       getBookingCollectionWithConverter();

//   return collectionReference.doc(bookingData.id).update({
//     'fromDate': bookingData.fromDate.millisecondsSinceEpoch,
//     'toDate': bookingData.toDate.millisecondsSinceEpoch,
//   });
// }
