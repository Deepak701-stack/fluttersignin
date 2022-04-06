import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignin/loginController.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget{
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginPage'),),
      body: Center(
        child: Obx((){
          if(controller.googleAccount.value==null)
            return buildLoginButton();
          else {
            CollectionReference users = FirebaseFirestore.instance.collection('users');
            users.add({
              'name':controller.googleAccount.value?.displayName,
              'email':controller.googleAccount.value?.email
              });
            return buildProfileView();
          }
        }),
      ),
    );
  }

  FloatingActionButton buildLoginButton(){
    return FloatingActionButton.extended(onPressed: (){
        controller.login();
      },
        label: Text('Sign in with Google'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
    );
  }

  Column buildProfileView(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: Image.network(controller.googleAccount.value?.photoUrl ?? '').image,
          radius: 100,
        ),
        Text(controller.googleAccount.value?.displayName ?? ''),
        Text(controller.googleAccount.value?.email ?? ''),

        ActionChip(label: Text('Logout'), onPressed: (){
          controller.logout();
        })
      ],
    );
  }
}