import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/my_courses/my_courses.dart';
import 'package:attendance_tracker/screens/administration/administration.dart';
import 'package:attendance_tracker/screens/take_attendance/take_attendance.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TakeAttendance()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2,
                  vertical: kDefaultPadding / 2),
              margin: const EdgeInsets.fromLTRB(kDefaultPadding,
                  kDefaultPadding * 2, kDefaultPadding, kDefaultPadding / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kPrimaryColor2.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: const Offset(0.5, 5), // changes position of shadow
                  ),
                ],
              ),
              height: 160,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.userCheck,
                        color: Colors.white.withOpacity(0.8),
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).takeAttendance,
                        style: TextStyle(
                          color: kBackgroundColor.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCourses()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2,
                  vertical: kDefaultPadding / 2),
              margin: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kPrimaryColor3.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: const Offset(0.5, 5), // changes position of shadow
                  ),
                ],
              ),
              height: 160,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.bookOpen,
                        color: Colors.white.withOpacity(0.8),
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).myCourses,
                        style: TextStyle(
                          color: kBackgroundColor.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Administration()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 2,
                  vertical: kDefaultPadding / 2),
              margin: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kPrimaryColor.withOpacity(0.75),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 5,
                    offset: const Offset(0.5, 5), // changes position of shadow
                  ),
                ],
              ),
              height: 160,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.users,
                        color: Colors.white.withOpacity(0.8),
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).administration,
                        style: TextStyle(
                          color: kBackgroundColor.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
