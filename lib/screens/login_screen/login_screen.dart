import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _validateemail = false;
  bool _validatepassword = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  int textfieldempty = 0;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 120,
        centerTitle: true,
        title: Container(
          child: Text(
            'NurulQuran Attendance',
            style: TextStyle(
              color: kPrimaryColor3,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              letterSpacing: -0.5,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, 0),
            child: Center(
              child: Text(
                'Please email at it@nrq.no for login or password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(
                kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2,
              vertical: kDefaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
                onChanged: (text) {
                  if (mounted) {
                    setState(() {
                      _validateemail = false;
                    });
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorText: _validateemail ? 'field required' : null,
                  hintText: 'Email',
                  prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 0),
                      child: Icon(Icons.mail_outline_outlined)),
                )),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(
                kDefaultPadding, kDefaultPadding, kDefaultPadding, 0),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding / 2,
              vertical: kDefaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
                onChanged: (text) {
                  if (mounted) {
                    setState(() {
                      _validatepassword = false;
                    });
                    if (passwordController.text != '') {
                      setState(() {
                        textfieldempty = 1;
                      });
                    } else {
                      setState(() {
                        textfieldempty = 0;
                      });
                    }
                  }
                },
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorText: _validatepassword ? 'field required' : null,
                  hintText: AppLocalizations.of(context).password,
                  prefixIcon: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 0),
                      child: Icon(Icons.password_outlined)),
                )),
          ),
          GestureDetector(
            onTap: () {
              authService.signInWithEmailandPassword(
                context,
                emailController.text,
                passwordController.text,
              );
              if (mounted) {
                setState(() {
                  passwordController.text.isEmpty
                      ? _validatepassword = true
                      : _validatepassword = false;
                });
                setState(() {
                  emailController.text.isEmpty
                      ? _validateemail = true
                      : _validateemail = false;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                  kDefaultPadding, kDefaultPadding * 2, kDefaultPadding, 0),
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 3,
                vertical: kDefaultPadding / 1.5,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor2]),
                color: kPrimaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                AppLocalizations.of(context).login,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
