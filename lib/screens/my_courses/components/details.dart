import 'package:attendance_tracker/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentDetails extends StatefulWidget {
  final String name;
  final String studentid;
  final String coursename;
  final String courseID;
  const StudentDetails(
      {Key? key,
      required this.name,
      required this.studentid,
      required this.coursename,
      required this.courseID})
      : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  List keyspro = [];
  List keys = [];

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
                    text: widget.name + '\n',
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
      body: SingleChildScrollView(
        child: buildOne(context),
      ),
    );
  }

  Widget buildOne(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(widget.studentid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            setKeys(snapshot.data![widget.courseID].keys.toList());
            return Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 1.5, vertical: kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).address + ": ",
                        style: TextStyle(
                            color: kTextColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(snapshot.data!['address'],
                          style:
                              const TextStyle(color: kTextColor2, fontSize: 15))
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).father + ": ",
                        style: TextStyle(
                            color: kTextColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(snapshot.data!['fathername'],
                          style:
                              const TextStyle(color: kTextColor2, fontSize: 15))
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).mother + ": ",
                        style: TextStyle(
                            color: kTextColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(snapshot.data!['mothername'],
                          style:
                              const TextStyle(color: kTextColor2, fontSize: 15))
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).phone + ": ",
                        style: TextStyle(
                            color: kTextColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(snapshot.data!['phonenumber'],
                          style:
                              const TextStyle(color: kTextColor2, fontSize: 15))
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.1, color: kTextColor2)),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).dato,
                            style: TextStyle(
                                color: kTextColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                          child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.1, color: kTextColor2)),
                        child: const Center(
                          child: Text(
                            'Status',
                            style: TextStyle(
                                color: kTextColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 5),
                  keys.isEmpty
                      ? const Center(
                          child: Text('No record yet.'),
                        )
                      : buildTable(context, snapshot.data!)
                ],
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  void setKeys(List initial) {
    for (int i = 0; i < initial.length; i++) {
      keyspro.add(DateFormat('dd/MM/yy').parse(initial[i]));
    }
    keyspro..sort();
    for (int j = 0; j < keyspro.length; j++) {
      keys.add(DateFormat('dd/MM/yy').format(keyspro[j]));
    }
  }

  Widget buildTable(BuildContext context, DocumentSnapshot snapshot) {
    return Column(
      children: [
        for (int y = 0; y < keys.length; y++)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.1, color: kTextColor2)),
                    child: Center(
                      child: Text(
                        keys[y],
                        style:
                            const TextStyle(color: kTextColor2, fontSize: 20),
                      ),
                    ),
                  )),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.1, color: kTextColor2)),
                    child: Center(
                      child: Text(
                        snapshot[widget.courseID][keys[y]],
                        style:
                            const TextStyle(color: kTextColor2, fontSize: 20),
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
      ],
    );
  }
}
