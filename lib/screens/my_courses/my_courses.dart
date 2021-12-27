import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/my_courses/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            margin: const EdgeInsets.only(left: kDefaultPadding / 1.5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).mine + '\n',
                    style: TextStyle(
                        color: kPrimaryColor3,
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        letterSpacing: -0.5,
                        height: 1),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).kurs,
                    style: TextStyle(
                      color: kPrimaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0,
                      letterSpacing: -0.5,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        actions: [
          Container(
              margin: const EdgeInsets.only(left: kDefaultPadding * 1.5),
              child: const BackButton(color: Colors.black)),
        ],
      ),
      body: const Body(),
    );
  }
}
