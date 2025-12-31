import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelClass {
  final String uuid;
  final String accountType;
  final String name;
  final String email;
  final String contactNumber;
  final String homeAddress;
  final GeoPoint appearedLocation;
  final String lastAppeared;
  final String accountCreated;
  final String profileImage;

  UserModelClass({
    this.uuid,
    this.accountType,
    this.name,
    this.email,
    this.contactNumber,
    this.homeAddress,
    this.appearedLocation,
    this.lastAppeared,
    this.accountCreated,
    this.profileImage,
  });

  factory UserModelClass.fromDocument(DocumentSnapshot doc) {
    return UserModelClass(
      uuid: doc['uuid'],
      accountType: doc['accountType'],
      name: doc['name'],
      email: doc['email'],
      contactNumber: doc['contactNumber'],
      homeAddress: doc['homeAddress'],
      appearedLocation: doc['appearedLocation'],
      lastAppeared: doc['lastAppeared'],
      accountCreated: doc['accountCreated'],
      profileImage: doc['profileImage'],
    );
  }
}
