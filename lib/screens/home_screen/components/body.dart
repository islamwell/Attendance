import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/my_courses/my_courses.dart';
import 'package:attendance_tracker/screens/administration/administration.dart';
import 'package:attendance_tracker/screens/take_attendance/take_attendance.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: ListView(
        children: [
          const SizedBox(height: kDefaultPadding),

          // Take Attendance Card
          _buildModernCard(
            context: context,
            title: AppLocalizations.of(context).takeAttendance,
            subtitle: 'Mark student attendance for today',
            icon: FontAwesomeIcons.userCheck,
            color: kPrimaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TakeAttendance()),
              );
            },
          ),

          const SizedBox(height: kDefaultPadding),

          // My Courses Card
          _buildModernCard(
            context: context,
            title: AppLocalizations.of(context).myCourses,
            subtitle: 'View courses and attendance reports',
            icon: FontAwesomeIcons.bookOpen,
            color: kSecondaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCourses()),
              );
            },
          ),

          const SizedBox(height: kDefaultPadding),

          // Administration Card
          _buildModernCard(
            context: context,
            title: AppLocalizations.of(context).administration,
            subtitle: 'Manage courses and students',
            icon: FontAwesomeIcons.users,
            color: kTertiaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Administration()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(kLargePadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                ),
                child: FaIcon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(width: kDefaultPadding),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
