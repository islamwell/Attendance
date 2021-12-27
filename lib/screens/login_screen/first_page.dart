import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final User? userd = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final phonenumberController = TextEditingController();
  String phonnumbstr = '';
  @override
  void dispose() {
    nameController.dispose();
    phonenumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

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
            const FaIcon(
              FontAwesomeIcons.glasses,
              color: kPrimaryColor,
              size: 35,
            ),
            Container(
              margin: const EdgeInsets.only(left: kDefaultPadding / 1.5),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: AppLocalizations.of(context).personal + '\n',
                      style: TextStyle(
                          color: kPrimaryColor3,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: -0.5,
                          height: 1),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context).info,
                      style: TextStyle(
                          color: kPrimaryColor3,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: -0.5,
                          height: 1),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                child: Image.asset("assets/images/nurulquran_logo.jpg"),
              )),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: kDefaultPadding * 2, horizontal: kDefaultPadding),
                child: Text(
                  AppLocalizations.of(context).firstpage,
                  style: TextStyle(color: kTextColor2, fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Wrapper()));
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(
                      vertical: kDefaultPadding * 2,
                      horizontal: kDefaultPadding),
                  child: Center(
                    child: Text(
                      'If you think there is an error, please click here to restart the app.',
                      style: TextStyle(
                          color: kTextColor2.withOpacity(0.7), fontSize: 18),
                    ),
                  ),
                ),
              ),
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
              Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(
                          kDefaultPadding, kDefaultPadding * 2, 0, 0),
                      child: Icon(
                        Icons.phone,
                        color: Colors.grey[500],
                      ),
                    )),
                Expanded(
                  flex: 10,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(kDefaultPadding,
                        kDefaultPadding * 2, kDefaultPadding, 0),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1.0, color: kTextColor2))),
                      /*onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },*/
                    ),
                  ),
                ),
              ]),
              Container(
                color: Colors.transparent,
                margin: const EdgeInsets.only(top: kDefaultPadding * 4),
                child: Center(
                  child: TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('teachers')
                            .doc(userd!.uid)
                            .set(
                          {
                            'name': nameController.text,
                            'phonenumber': phonnumbstr,
                            'courses': []
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please wait...')));
                        Future.delayed(const Duration(seconds: 5), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Wrapper(),
                                fullscreenDialog: true),
                          );
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding,
                            horizontal: kDefaultPadding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kPrimaryColor2,
                            gradient: const LinearGradient(
                                colors: [kPrimaryColor, kPrimaryColor2])),
                        child: Text(
                          AppLocalizations.of(context).submit,
                          style: TextStyle(
                              color: kBackgroundColor.withOpacity(0.9),
                              fontSize: 15),
                        ),
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
