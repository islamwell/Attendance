import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/home_screen/home_screen.dart';
import 'package:attendance_tracker/screens/take_attendance/components/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendancePage extends StatefulWidget {
  final String date;
  final String coursename;
  final String courseid;
  const AttendancePage(
      {Key? key,
      required this.date,
      required this.coursename,
      required this.courseid})
      : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
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
                    text: widget.date + '\n',
                    style: const TextStyle(
                        color: kPrimaryColor3,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        letterSpacing: -0.5,
                        height: 1),
                  ),
                  TextSpan(
                    text: widget.coursename,
                    style: const TextStyle(
                      color: kPrimaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      letterSpacing: -0.5,
                      height: 1.1,
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
              child: TextButton(
                child: Text('Finish'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                        fullscreenDialog: true),
                  );
                },
              )),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .doc(widget.courseid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data!['students']).isEmpty) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < snapshot.data!['students'].length;
                          i++)
                        StudentStatus(
                            studentID: snapshot.data!['students'][i],
                            courseID: widget.courseid,
                            date: widget.date,
                            num: i + 1)
                    ],
                  ),
                );
              }
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          }),
    );
  }
}

class StudentStatus extends StatefulWidget {
  final String studentID;
  final String courseID;
  final String date;
  final int num;
  const StudentStatus(
      {Key? key,
      required this.studentID,
      required this.courseID,
      required this.date,
      required this.num})
      : super(key: key);

  @override
  _StudentStatusState createState() => _StudentStatusState();
}

class _StudentStatusState extends State<StudentStatus> {
  String name = 'x';
  double percentage = 50;
  Color backexc = Colors.transparent;
  Color backabs = Colors.transparent;
  Color backpre = Colors.transparent;
  String tray = '';
  late bool goodtogo;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(
            kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
        height: 110,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kPrimaryColor, width: 1.7)),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('students')
                .doc(widget.studentID)
                .snapshots(),
            builder: (context, studentsnapshot) {
              if (studentsnapshot.hasData) {
                try {
                  tray = studentsnapshot.data![widget.courseID][widget.date];
                  goodtogo = true;
                } catch (e) {
                  goodtogo = false;
                }
                if (goodtogo) {
                  if ((studentsnapshot.data![widget.courseID])[widget.date] ==
                      'Excused') {
                    if (mounted) {
                      backabs = Colors.transparent;
                      backpre = Colors.transparent;
                      backexc = Colors.yellow.withOpacity(0.6);
                    }
                  } else if ((studentsnapshot
                          .data![widget.courseID])[widget.date] ==
                      'Absent') {
                    if (mounted) {
                      backabs = Colors.red.withOpacity(0.6);
                      backpre = Colors.transparent;
                      backexc = Colors.transparent;
                    }
                  } else if ((studentsnapshot
                          .data![widget.courseID])[widget.date] ==
                      'Present') {
                    if (mounted) {
                      backabs = Colors.transparent;
                      backpre = Colors.green.withOpacity(0.6);
                      backexc = Colors.transparent;
                    }
                  }
                } else {
                  backabs = Colors.transparent;
                  backpre = Colors.transparent;
                  backexc = Colors.transparent;
                }

                name = studentsnapshot.data!['name'];
                return Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: kDefaultPadding, left: kDefaultPadding),
                          child: Text(widget.num.toString())),
                    ),
                    Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Student0Details(
                                        name: studentsnapshot.data!['name'],
                                        studentid: studentsnapshot.data!.id,
                                      )),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: kTextColor2.withOpacity(0.9)),
                              ),
                            ),
                          ),
                        )),
                    // Excused
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: backexc,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      backabs = Colors.transparent;
                                      backpre = Colors.transparent;
                                      backexc = Colors.yellow.withOpacity(0.6);
                                    });
                                  }
                                  FirebaseFirestore.instance
                                      .collection('students')
                                      .doc(widget.studentID)
                                      .set(
                                    {
                                      widget.courseID: {widget.date: 'Excused'}
                                    },
                                    SetOptions(merge: true),
                                  );
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.caretUp,
                                  color: Colors.yellow[800],
                                  size: 45,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(AppLocalizations.of(context).excused,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black)),
                              SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        )),
                    // Absent
                    Expanded(
                        flex: 2,
                        child: Container(
                          color: backabs,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      backabs = Colors.red.withOpacity(0.6);
                                      backpre = Colors.transparent;
                                      backexc = Colors.transparent;
                                    });
                                  }
                                  FirebaseFirestore.instance
                                      .collection('students')
                                      .doc(widget.studentID)
                                      .set(
                                    {
                                      widget.courseID: {widget.date: 'Absent'}
                                    },
                                    SetOptions(merge: true),
                                  );
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.times,
                                  color: Colors.red,
                                ),
                              ),
                              Text(AppLocalizations.of(context).absent,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black))
                            ],
                          ),
                        )),
                    // Present
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            color: backpre,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        backabs = Colors.transparent;
                                        backpre = Colors.green.withOpacity(0.6);
                                        backexc = Colors.transparent;
                                      });
                                    }
                                    FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(widget.studentID)
                                        .set(
                                      {
                                        widget.courseID: {
                                          widget.date: 'Present'
                                        }
                                      },
                                      SetOptions(merge: true),
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.check,
                                    color: Colors.green,
                                  )),
                              Text(AppLocalizations.of(context).present,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black)),
                            ],
                          ),
                        )),
                  ],
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }));
  }
}
