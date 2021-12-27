import 'package:attendance_tracker/screens/home_screen/home_screen.dart';
import 'package:attendance_tracker/screens/login_screen/first_page.dart';
import 'package:attendance_tracker/screens/login_screen/login_screen.dart';
import 'package:attendance_tracker/screens/services/auth_service.dart';
import 'package:attendance_tracker/screens/wrapper_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late bool exist;
  @override
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserAttr?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<UserAttr?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserAttr? user = snapshot.data;
            if (user == null) {
              return const LoginScreen();
            } else {
              return Wrapper2();
            }
          } else {
            return const Scaffold(
                body: Center(child: CupertinoActivityIndicator()));
          }
        });
  }
}
