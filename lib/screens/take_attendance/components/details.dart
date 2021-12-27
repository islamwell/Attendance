import 'package:attendance_tracker/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Student0Details extends StatefulWidget {
  final String name;
  final String studentid;

  const Student0Details({
    Key? key,
    required this.name,
    required this.studentid,
  }) : super(key: key);

  @override
  _Student0DetailsState createState() => _Student0DetailsState();
}

class _Student0DetailsState extends State<Student0Details> {
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
                    text: widget.name,
                    style: const TextStyle(
                        color: kPrimaryColor3,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        letterSpacing: -0.5,
                        height: 1),
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
            return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 1.5,
                    vertical: kDefaultPadding),
                child: Column(children: [
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
                ]));
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}
