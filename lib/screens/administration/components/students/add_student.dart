import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
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

  String phonnumbstr = '';
  List chosen = [];
  List chosenID = [];
  String docID = '';
  String initialCountry = 'NO';
  PhoneNumber number = PhoneNumber(isoCode: 'NO');
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
                    text: AppLocalizations.of(context).add + '\n',
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
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    setState(() {
                      phonnumbstr = number.phoneNumber.toString();
                    });
                  },
                  onInputValidated: (bool value) {},
                  selectorConfig: const SelectorConfig(
                    setSelectorButtonAsPrefixIcon: true,
                    showFlags: false,
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: phonenumberController,
                  formatInput: false,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.number,
                  inputBorder: InputBorder.none,
                  inputDecoration: InputDecoration(
                      labelText: AppLocalizations.of(context).phone,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 1.0, color: kTextColor2))),
                  /*onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },*/
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
                                      value: chosen.contains(
                                          snapshot.data!.docs[index].id),
                                      onChanged: (newValue) {
                                        if (chosen.contains(
                                            snapshot.data!.docs[index].id)) {
                                          if (mounted) {
                                            setState(() {
                                              chosen.remove(snapshot
                                                  .data!.docs[index].id);
                                            });
                                          }
                                        } else {
                                          if (mounted) {
                                            setState(() {
                                              chosen.add(snapshot
                                                  .data!.docs[index].id);
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
                                  for (int j = 0; j < chosen.length; j++) {}
                                  await FirebaseFirestore.instance
                                      .collection('students')
                                      .add({
                                    'name': nameController.text,
                                    'mothername': motherController.text,
                                    'fathername': fatherController.text,
                                    'address': addressController.text,
                                    'phonenumber': phonnumbstr,
                                    'courses': chosen,
                                  }).then((value) {
                                    if (mounted) {
                                      setState(() {
                                        docID = value.id;
                                      });
                                    }
                                  });
                                  for (int b = 0; b < chosen.length; b++) {
                                    await FirebaseFirestore.instance
                                        .collection('courses')
                                        .doc(chosen[b])
                                        .update(
                                      {
                                        'students':
                                            FieldValue.arrayUnion([docID])
                                      },
                                    );
                                  }
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
                                                  .createdStudent)));
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
                                        color:
                                            kBackgroundColor.withOpacity(0.9),
                                        fontSize: 20),
                                  ),
                                )),
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
