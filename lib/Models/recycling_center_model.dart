import 'package:cloud_firestore/cloud_firestore.dart';

class RecyclingCenterModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final GeoPoint location;

  RecyclingCenterModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.location,
  });

  factory RecyclingCenterModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return RecyclingCenterModel(
      id: documentSnapshot['id'],
      name: documentSnapshot['name'],
      address: documentSnapshot['address'],
      phone: documentSnapshot['phone'],
      location: documentSnapshot['location'],
    );
  }
}
