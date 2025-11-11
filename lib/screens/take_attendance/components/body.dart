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
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
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
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(
                                        kDefaultBorderRadius),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: kDefaultPadding),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDay,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.edit_calendar,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
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
                                    builder: (context) => AttendancePage(
                                          date: _formatDate,
                                          coursename: snapshot.data!.docs[i]
                                              ['name'],
                                          courseid: snapshot.data!.docs[i].id,
                                        )),
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
                                    kSecondaryColor,
                                    kSecondaryColor.withOpacity(0.7),
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
