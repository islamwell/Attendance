import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask(
      {Key? key,
      required this.child,
      required this.firstcol,
      required this.secondcol})
      : super(key: key);
  final Widget child;
  final Color firstcol;
  final Color secondcol;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [firstcol, secondcol],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class CheckExist {
  static Future<bool> doc(String uid) async {
    late bool exist;
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(uid)
          .get()
          .then((DocumentSnapshot signedinSnapshot) {
        exist = signedinSnapshot.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }
}

class Utils {
  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Done'),
            onPressed: onClicked,
          ),
        ),
      );
}
