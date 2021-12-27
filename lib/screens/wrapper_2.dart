import 'package:attendance_tracker/screens/home_screen/home_screen.dart';
import 'package:attendance_tracker/screens/login_screen/first_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Wrapper2 extends StatefulWidget {
  const Wrapper2({Key? key}) : super(key: key);

  @override
  _Wrapper2State createState() => _Wrapper2State();
}

class _Wrapper2State extends State<Wrapper2> {
  final User? userd = FirebaseAuth.instance.currentUser;
  late bool exist;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkExist(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<bool> usnapshot) {
        List<Widget> children;
        if (usnapshot.hasData) {
          if (exist) {
            return HomeScreen();
          } else {
            return FirstPage();
          }
        } else {
          return const Scaffold(
              body: Center(child: CupertinoActivityIndicator()));
        }
      },
    );
  }

  Future<bool> checkExist() async {
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userd!.uid)
          .get()
          .then((doc) {
        setState(() {
          exist = doc.exists;
        });
      });
      return exist;
    } catch (e) {
      // If any error
      setState(() {
        exist = false;
      });
      return exist;
    }
  }
}
