import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/take_attendance/components/attendance_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final User? user = FirebaseAuth.instance.currentUser;
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var _formatDate = DateFormat('dd/MM/yy').format(dateTime);
    var _formatDay = DateFormat('EEEE').format(dateTime);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('instructor', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data!.docs).isNotEmpty) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5,
                          vertical: kDefaultPadding),
                      child: Text(
                        AppLocalizations.of(context).chooseDate,
                        style: TextStyle(
                            color: kTextColor3,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: [
                              SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                  minimumYear: 2020,
                                  maximumYear: DateTime.now().year + 5,
                                  initialDateTime: dateTime,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (dateTime) {
                                    if (mounted) {
                                      setState(() {
                                        this.dateTime = dateTime;
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(AppLocalizations.of(context).done),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [kPrimaryColor, kPrimaryColor2]),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                    fontSize: 30),
                              ),
                              Text(
                                _formatDay,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor3,
                                    fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5,
                          vertical: kDefaultPadding),
                      child: Text(
                        AppLocalizations.of(context).chooseCourse,
                        style: TextStyle(
                            color: kTextColor3,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    for (int i = 0; i < snapshot.data!.docs.length; i++)
                      Container(
                        margin: EdgeInsets.only(bottom: kDefaultPadding),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendancePage(
                                        date: _formatDate,
                                        coursename: snapshot.data!.docs[i]
                                            ['name'],
                                        courseid: snapshot.data!.docs[i].id,
                                      )),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            height: 110,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [kPrimaryColor2, kPrimaryColor]),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data!.docs[i]['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor3,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(AppLocalizations.of(context).noCourse),
              );
            }
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}
