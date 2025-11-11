import 'dart:io';
import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/my_courses/components/details.dart';
import 'package:attendance_tracker/screens/services/pdf_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        margin: const EdgeInsets.only(
                            bottom: kDefaultPadding,
                            left: kDefaultPadding,
                            right: kDefaultPadding),
                        child: Card(
                          elevation: 2,
                          child: InkWell(
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
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRadius),
                            child: Container(
                              padding: const EdgeInsets.all(kLargePadding),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kDefaultBorderRadius),
                                gradient: LinearGradient(
                                  colors: [
                                    kPrimaryColor,
                                    kPrimaryColor.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                        kDefaultPadding),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(
                                          kDefaultBorderRadius),
                                    ),
                                    child: const Icon(
                                      Icons.class_outlined,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: kDefaultPadding),
                                  Expanded(
                                    child: Text(
                                      snapshot.data!.docs[i]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
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
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    studentPercentage();
  }

  Future<void> _generateAndSharePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      // Get teacher name
      final user = FirebaseAuth.instance.currentUser;
      final teacherDoc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(user!.uid)
          .get();
      final teacherName = teacherDoc.data()?['name'] ?? 'Unknown Teacher';

      // Generate PDF
      final pdfFile = await PdfService.generateCourseReport(
        courseId: widget.courseID,
        courseName: widget.coursename,
        teacherName: teacherName,
      );

      setState(() {
        _isGeneratingPdf = false;
      });

      // Show share options
      _showShareOptions(pdfFile);
    } catch (e) {
      setState(() {
        _isGeneratingPdf = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  void _showShareOptions(File pdfFile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: kPrimaryColor),
              title: const Text('Preview PDF'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.previewPdf(pdfFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: kSecondaryColor),
              title: const Text('Share'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.sharePdf(pdfFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: kTertiaryColor),
              title: const Text('Share via Email'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.shareViaEmail(pdfFile, '');
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: kPrimaryColor),
              title: const Text('Print'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.printPdf(pdfFile);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.coursename,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context).attendanceReport,
              style: TextStyle(
                fontSize: 12,
                color: kOnSurfaceColor.withOpacity(0.7),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _isGeneratingPdf ? null : _generateAndSharePdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(kDefaultPadding),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
            childAspectRatio: 1.3,
          ),
          itemCount: widget.studentList.length,
          itemBuilder: (context, i) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('students')
                  .doc(widget.studentList[i])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final attendancePercentage = stat.length > i ? stat[i][4] : 0.0;
                  final color = attendancePercentage >= 75
                      ? kPresentColor
                      : (attendancePercentage >= 50
                          ? kExcusedColor
                          : kAbsentColor);

                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        if (stat[i][3] == 0) {
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
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      child: Container(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderRadius),
                          border: Border.all(
                            color: color,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: color,
                              size: 32,
                            ),
                            const SizedBox(height: kSmallPadding),
                            Text(
                              snapshot.data!['name'],
                              style: TextStyle(
                                color: kOnSurfaceColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: kSmallPadding),
                            Text(
                              '${attendancePercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: _isGeneratingPdf
          ? const CircularProgressIndicator()
          : null,
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
