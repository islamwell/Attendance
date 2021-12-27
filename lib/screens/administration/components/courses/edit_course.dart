import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/home_screen/home_screen.dart';
import 'package:attendance_tracker/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditCourse extends StatefulWidget {
  final String courseName;
  final String courseID;
  const EditCourse({Key? key, required this.courseName, required this.courseID})
      : super(key: key);

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            margin: const EdgeInsets.only(left: kDefaultPadding / 1.5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: widget.courseName,
                    style: TextStyle(
                      color: kPrimaryColor3,
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
              child: TextButton(
                child: Text('Finish'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Wrapper(),
                        fullscreenDialog: true),
                  );
                },
              )),
        ],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('courses')
                  .doc(widget.courseID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('students')
                          .snapshots(),
                      builder: (context, studentsnapshot) {
                        if (studentsnapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: studentsnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    child: CheckboxListTile(
                                      title: Text(studentsnapshot
                                          .data!.docs[index]['name']),
                                      value: (studentsnapshot.data!.docs[index]
                                              ["courses"])
                                          .contains(widget.courseID),
                                      onChanged: (newValue) async {
                                        if ((studentsnapshot.data!.docs[index]
                                                ["courses"])
                                            .contains(widget.courseID)) {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(studentsnapshot
                                                  .data!.docs[index].id)
                                              .update(
                                            {
                                              'courses': FieldValue.arrayRemove(
                                                  [widget.courseID])
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('courses')
                                              .doc(widget.courseID)
                                              .update(
                                            {
                                              'students':
                                                  FieldValue.arrayRemove([
                                                studentsnapshot
                                                    .data!.docs[index].id
                                              ])
                                            },
                                          );
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(studentsnapshot
                                                  .data!.docs[index].id)
                                              .update(
                                            {
                                              'courses': FieldValue.arrayUnion(
                                                  [widget.courseID])
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('courses')
                                              .doc(widget.courseID)
                                              .update(
                                            {
                                              'students':
                                                  FieldValue.arrayUnion([
                                                studentsnapshot
                                                    .data!.docs[index].id
                                              ])
                                            },
                                          );
                                        }
                                      },
                                      controlAffinity: ListTileControlAffinity
                                          .leading, //  <-- leading Checkbox
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      });
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
