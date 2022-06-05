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

CollectionReference<UserBookingData> getUserBookingCollectionWithConverter(){
  return FirebaseFirestore.instance
  .collection(UserBookingData.COLLECTION_NAME)
  .withConverter(
    fromFirestore: (snapshot, _) => UserBookingData.fromJson(snapshot.data()!),
     toFirestore: (data, _) => data.toJson()
    );
}





Future<void> addBookingToFirestore(String match, String stadium, String date) {
  CollectionReference<BookingData> collectionReference =
      getBookingCollectionWithConverter();

  DocumentReference<BookingData> documentReference =
      collectionReference.doc(); // to create new object with new id

  BookingData data = BookingData(
      id: documentReference.id, match: match, stadium: stadium, date: date);

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

Future<void> addUserBookingToFirebase(UserBookingData userBookingData){
  CollectionReference<UserBookingData> collectionReference =
      getUserBookingCollectionWithConverter();

  DocumentReference<UserBookingData> documentReference =
      collectionReference.doc(); // to create new object with new id

  UserBookingData data = userBookingData;

  return documentReference.set(data);
}




