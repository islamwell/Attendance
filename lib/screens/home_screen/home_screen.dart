import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/home_screen/components/body.dart';
import 'package:attendance_tracker/screens/services/auth_service.dart';
import 'package:attendance_tracker/utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: false,
        title: Row(children: [
          Container(
              margin: const EdgeInsets.only(left: kDefaultPadding),
              child: const RadiantGradientMask(
                child: FaIcon(
                  FontAwesomeIcons.school,
                  color: Colors.white,
                  size: 50,
                ),
                firstcol: kPrimaryColor3,
                secondcol: kPrimaryColor2,
              )),
          Container(
            margin: const EdgeInsets.only(left: kDefaultPadding),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context).mainTitle0 + '\n',
                    style: TextStyle(
                        color: kPrimaryColor3,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        letterSpacing: -0.5,
                        height: 1),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context).mainTitle1,
                    style: TextStyle(
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
          IconButton(
              onPressed: () {
                Dialogcu.signoutDialog(context);
              },
              icon: const Icon(
                Icons.exit_to_app_rounded,
                color: kPrimaryColor,
                size: 25,
              ))
        ],
      ),
      body: const Body(),
    );
  }
}
