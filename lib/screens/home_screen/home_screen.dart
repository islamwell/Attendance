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
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.graduationCap,
              color: kPrimaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).mainTitle0,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).mainTitle1,
                  style: TextStyle(
                    fontSize: 12,
                    color: kOnSurfaceColor.withOpacity(0.7),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Dialogcu.signoutDialog(context);
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
