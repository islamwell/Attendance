import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditStudent extends StatefulWidget {
  final DocumentSnapshot<Object?> student;
  const EditStudent({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final nameController = TextEditingController();
  final motherController = TextEditingController();
  final fatherController = TextEditingController();
  final addressController = TextEditingController();
  final phonenumberController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    motherController.dispose();
    fatherController.dispose();
    addressController.dispose();
    phonenumberController.dispose();
    super.dispose();
  }

  String initialCountry = 'NO';
  PhoneNumber number = PhoneNumber(isoCode: 'NO');
  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        nameController.text = widget.student['name'];
        motherController.text = widget.student['mothername'];
        fatherController.text = widget.student['fathername'];
        addressController.text = widget.student['address'];
        phonenumberController.text = widget.student['phonenumber']
            .substring(0, widget.student['phonenumber'].length);
      });
    }
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
              child: TextButton(
                child: Text('Save'),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('students')
                      .doc(widget.student.id)
                      .update(
                    {
                      'name': nameController.text,
                      'mothername': motherController.text,
                      'fathername': fatherController.text,
                      'address': addressController.text,
                      'phonenumber': phonenumberController.text
                    },
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Wrapper(),
                        fullscreenDialog: true),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context).done)));
                },
              )),
        ],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(
                    kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Fullname is required.';
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.portrait_rounded),
                      labelText: AppLocalizations.of(context).fullname,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(
                    kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Address is required.";
                    } else {
                      return null;
                    }
                  },
                  controller: addressController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.add_location_alt_outlined),
                      labelText: AppLocalizations.of(context).address,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(
                    kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Father's Name is required.";
                    } else {
                      return null;
                    }
                  },
                  controller: fatherController,
                  decoration: InputDecoration(
                      icon: Container(
                          margin: const EdgeInsets.only(
                              left: kDefaultPadding / 2,
                              right: kDefaultPadding / 2),
                          child: const FaIcon(FontAwesomeIcons.male)),
                      labelText: AppLocalizations.of(context).father,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(
                    kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Mother's Name is required.";
                    } else {
                      return null;
                    }
                  },
                  controller: motherController,
                  decoration: InputDecoration(
                      icon: Container(
                          margin: const EdgeInsets.only(
                              left: kDefaultPadding / 2,
                              right: (kDefaultPadding / 2) - 3),
                          child: const FaIcon(FontAwesomeIcons.female)),
                      labelText: AppLocalizations.of(context).mother,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(
                    kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Phone Number is required.";
                    } else {
                      return null;
                    }
                  },
                  controller: phonenumberController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: AppLocalizations.of(context).phone,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ),
              const SizedBox(height: 50),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 400,
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
                                      value: widget.student['courses'].contains(
                                          snapshot.data!.docs[index].id),
                                      onChanged: (newValue) async {
                                        if ((snapshot.data!.docs[index]
                                                ["students"])
                                            .contains(widget.student.id)) {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(widget.student.id)
                                              .update(
                                            {
                                              'courses':
                                                  FieldValue.arrayRemove([
                                                snapshot.data!.docs[index].id
                                              ])
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('courses')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update(
                                            {
                                              'students':
                                                  FieldValue.arrayRemove(
                                                      [widget.student.id])
                                            },
                                          );
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(widget.student.id)
                                              .update(
                                            {
                                              'courses': FieldValue.arrayUnion([
                                                snapshot.data!.docs[index].id
                                              ])
                                            },
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('courses')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update(
                                            {
                                              'students': FieldValue.arrayUnion(
                                                  [widget.student.id])
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
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
