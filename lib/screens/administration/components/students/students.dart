import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/administration/components/students/add_student.dart';
import 'package:attendance_tracker/screens/administration/components/students/edit_student.dart';
import 'package:attendance_tracker/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  late DocumentSnapshot chosenStudent;
  String name = 'Choose Student';
  double opac = 0;
  bool visible = false;
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
                      text: AppLocalizations.of(context).edit + '\n',
                      style: TextStyle(
                          color: kPrimaryColor3,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          letterSpacing: -0.5,
                          height: 1),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context).student,
                      style: TextStyle(
                        color: kPrimaryColor2,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
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
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('students').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 1.5,
                            vertical: kDefaultPadding),
                        child: Text(
                          AppLocalizations.of(context).editStudent,
                          style: TextStyle(
                              color: kTextColor3,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              opac = 1;
                              visible = true;
                            });
                            setState(() {
                              chosenStudent = snapshot.data!.docs[0];
                            });
                            setState(() {
                              name = chosenStudent['name'];
                            });
                          }
                          Utils.showSheet(context,
                              child: SizedBox(
                                height: 200,
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                      initialItem: 0),
                                  onSelectedItemChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        chosenStudent =
                                            snapshot.data!.docs[value];
                                      });
                                      setState(() {
                                        name = chosenStudent['name'];
                                      });
                                      setState(() {
                                        opac = 1;
                                        visible = true;
                                      });
                                    }
                                  },
                                  backgroundColor: Colors.white,
                                  itemExtent: 30,
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data!.docs.length;
                                        i++)
                                      Text(snapshot.data!.docs[i]['name'])
                                  ],
                                ),
                              ), onClicked: () {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          height: 100,
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
                                  name,
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
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: opac,
                        child: Visibility(
                            visible: visible,
                            child: Container(
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(
                                  top: kDefaultPadding * 4),
                              child: Center(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditStudent(
                                                student: chosenStudent)),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: kDefaultPadding,
                                          horizontal: kDefaultPadding),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: kPrimaryColor2,
                                          gradient: const LinearGradient(
                                              colors: [
                                                kPrimaryColor,
                                                kPrimaryColor2
                                              ])),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .editStudent,
                                        style: TextStyle(
                                            color: kBackgroundColor
                                                .withOpacity(0.9),
                                            fontSize: 20),
                                      ),
                                    )),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context).or,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        margin: const EdgeInsets.only(top: kDefaultPadding * 2),
                        child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddStudent()),
                                );
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
                                  AppLocalizations.of(context).addStudent,
                                  style: TextStyle(
                                      color: kBackgroundColor.withOpacity(0.9),
                                      fontSize: 20),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }));
  }
}
