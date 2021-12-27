import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/administration/components/courses/edit_course.dart';
import 'package:attendance_tracker/screens/wrapper.dart';
import 'package:attendance_tracker/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final nameController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  List chosen = [];
  List chosenID = [];
  String docID = '';
  late DocumentSnapshot chosenCourse;
  int val = 0;
  final User? user = FirebaseAuth.instance.currentUser;
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
                      text: AppLocalizations.of(context).add +
                          "/" +
                          AppLocalizations.of(context).edit +
                          AppLocalizations.of(context).kurs,
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
                child: const BackButton(color: Colors.black)),
          ],
        ),
        body: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 1.5,
                    vertical: kDefaultPadding),
                child: Text(
                  AppLocalizations.of(context).addCourse,
                  style: TextStyle(
                      color: kTextColor3,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(kDefaultPadding,
                    kDefaultPadding, kDefaultPadding, kDefaultPadding / 2),
                padding: const EdgeInsets.fromLTRB(kDefaultPadding / 2,
                    kDefaultPadding / 5, kDefaultPadding, kDefaultPadding / 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).courseName,
                      labelStyle: TextStyle(fontSize: 14),
                      prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(start: 0),
                          child: Icon(
                            Icons.book,
                          )),
                    )),
              ),
              const SizedBox(height: 50),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding),
                                    child: CheckboxListTile(
                                      title: Text(
                                          snapshot.data!.docs[index]['name']),
                                      value: chosen.contains(index),
                                      onChanged: (newValue) {
                                        if (chosen.contains(index)) {
                                          if (mounted) {
                                            setState(() {
                                              chosen.remove(index);
                                            });
                                          }
                                        } else {
                                          if (mounted) {
                                            setState(() {
                                              chosen.add(index);
                                            });
                                          }
                                        }
                                      },
                                      controlAffinity: ListTileControlAffinity
                                          .leading, //  <-- leading Checkbox
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: TextButton(
                                onPressed: () async {
                                  for (int j = 0; j < chosen.length; j++) {
                                    chosenID.add(snapshot.data!.docs[j].id);
                                  }
                                  await FirebaseFirestore.instance
                                      .collection('courses')
                                      .add({
                                    'name': nameController.text,
                                    'students': chosenID,
                                    'instructor': user!.uid,
                                  }).then((value) {
                                    if (mounted) {
                                      setState(() {
                                        docID = value.id;
                                      });
                                    }
                                  });
                                  for (int b = 0; b < chosenID.length; b++) {
                                    await FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(chosenID[b])
                                        .update(
                                      {
                                        'courses':
                                            FieldValue.arrayUnion([docID])
                                      },
                                    );
                                  }
                                  await FirebaseFirestore.instance
                                      .collection('teachers')
                                      .doc(user!.uid)
                                      .update(
                                    {
                                      'courses': FieldValue.arrayUnion([docID])
                                    },
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Wrapper(),
                                        fullscreenDialog: true),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .courseCreated)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kDefaultPadding,
                                      horizontal: kDefaultPadding),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: kPrimaryColor2,
                                      gradient: const LinearGradient(colors: [
                                        kPrimaryColor,
                                        kPrimaryColor2
                                      ])),
                                  child: Text(
                                    AppLocalizations.of(context).addCourse,
                                    style: TextStyle(
                                        color:
                                            kBackgroundColor.withOpacity(0.9),
                                        fontSize: 20),
                                  ),
                                )),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: kDefaultPadding * 2),
                              child: Text(AppLocalizations.of(context).or,
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('courses')
                                  .where('instructor', isEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if ((snapshot.data!.docs).isNotEmpty) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal:
                                                    kDefaultPadding * 1.5,
                                                vertical:
                                                    kDefaultPadding * 1.5),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                      .edit +
                                                  " " +
                                                  AppLocalizations.of(context)
                                                      .kurs,
                                              style: TextStyle(
                                                  color: kTextColor3,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          for (int i = 0;
                                              i < snapshot.data!.docs.length;
                                              i++)
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: kDefaultPadding),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditCourse(
                                                                courseID:
                                                                    snapshot
                                                                        .data!
                                                                        .docs[i]
                                                                        .id,
                                                                courseName: snapshot
                                                                        .data!
                                                                        .docs[i]
                                                                    ['name'])),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          kDefaultPadding),
                                                  height: 110,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                            colors: [
                                                          kPrimaryColor,
                                                          kPrimaryColor2
                                                        ]),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snapshot.data!.docs[i]
                                                              ['name'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  kPrimaryColor3,
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
                                      child: Text(AppLocalizations.of(context)
                                          .noCourse),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                              })
                        ],
                      );
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }),
            ]),
          ),
        ));
  }
}
