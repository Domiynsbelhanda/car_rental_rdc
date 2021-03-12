

import 'package:firebase_database/firebase_database.dart';

class Users{
  String fullName;
  String email;
  String phone;
  String image;
  String type;
  String id;

  Users({
    this.email,
    this.fullName,
    this.image,
    this.phone,
    this.id,
    this.type,
  });

  Users.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['name'];
    image = snapshot.value['image'];
    type = snapshot.value['type'];
  }

}