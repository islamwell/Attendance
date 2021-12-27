import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/my_courses/components/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(
                      height: 20,
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
                                  builder: (context) => StudentList(
                                      studentList: snapshot.data!.docs[i]
                                          ['students'],
                                      courseID: snapshot.data!.docs[i].id,
                                      coursename: snapshot.data!.docs[i]
                                          ['name'])),
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

class StudentList extends StatefulWidget {
  final List studentList;
  final String courseID;
  final String coursename;
  const StudentList(
      {Key? key,
      required this.studentList,
      required this.courseID,
      required this.coursename})
      : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List stat = [];
  List percList = [];
  @override
  void initState() {
    super.initState();
    studentPercentage();
  }

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
                    text: widget.coursename + '\n',
                    style: const TextStyle(
                        color: kPrimaryColor3,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        letterSpacing: -0.5,
                        height: 1),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).attendanceReport,
                    style: TextStyle(
                      color: kPrimaryColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
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
      body: Container(
        margin: const EdgeInsets.only(
            left: kDefaultPadding / 2, top: kDefaultPadding),
        child: Wrap(
          children: [
            for (int i = 0; i < widget.studentList.length; i++)
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .doc(widget.studentList[i])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          if (stat[i][3] == 0) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    AppLocalizations.of(context).noRecord)));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentDetails(
                                      name: snapshot.data!['name'],
                                      studentid: widget.studentList[i],
                                      coursename: widget.coursename,
                                      courseID: widget.courseID)),
                            );
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding / 2,
                                vertical: kDefaultPadding / 2),
                            height: 100,
                            width: (MediaQuery.of(context).size.width - 45) / 2,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  width: 2,
                                  color: stat[i][4] >= 75
                                      ? Colors.green
                                      : (stat[i][4] >= 50
                                          ? Colors.yellow
                                          : Colors.red)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(snapshot.data!['name'],
                                      style: TextStyle(
                                          color: kTextColor2.withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19)),
                                ),
                                const SizedBox(height: kDefaultPadding),
                                Center(
                                    child: Text(
                                        stat[i][4].toStringAsFixed(1) + '%',
                                        style: TextStyle(
                                            color: stat[i][4] >= 75
                                                ? Colors.green
                                                : (stat[i][4] >= 50
                                                    ? Colors.yellow[800]
                                                    : Colors.red)))),
                              ],
                            )),
                      );
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }

  void studentPercentage() async {
    for (int k = 0; k < widget.studentList.length; k++) {
      List temp = [];

      try {
        await FirebaseFirestore.instance
            .collection("students")
            .doc(widget.studentList[k])
            .get()
            .then((DocumentSnapshot studentSnapshot) {
          if (mounted) {
            setState(() {
              temp.addAll(studentSnapshot[widget.courseID].values.toList());
            });
          }
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            temp = [0, 0, 0, 0];
          });
        }
      }
      int all = 0;
      int pre = 0;
      int abs = 0;
      int exc = 0;
      if (temp.isEmpty) {
        if (mounted) {
          setState(() {
            stat.add([0, 0, 0, 0, 0]);
          });
        }
      }
      for (int g = 0; g < temp.length; g++) {
        if (temp[g] == 'Present') {
          pre++;
        } else if (temp[g] == 'Absent') {
          abs++;
        } else if (temp[g] == 'Excused') {
          exc++;
        }
        all++;
      }
      if (mounted) {
        setState(() {
          stat.add([pre, abs, exc, all, (100 / all) * pre]);
        });
      }
    }
  }
}
