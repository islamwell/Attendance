import 'dart:io';
import 'package:attendance_tracker/constants.dart';
import 'package:attendance_tracker/screens/services/pdf_service.dart';
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
  bool _isGeneratingPdf = false;

  Future<void> _generateStudentPdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final pdfFile = await PdfService.generateStudentReport(
        studentId: widget.studentid,
        studentName: widget.name,
        courseId: widget.courseID,
        courseName: widget.coursename,
      );

      setState(() {
        _isGeneratingPdf = false;
      });

      _showShareOptions(pdfFile);
    } catch (e) {
      setState(() {
        _isGeneratingPdf = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  void _showShareOptions(File pdfFile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: kPrimaryColor),
              title: const Text('Preview PDF'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.previewPdf(pdfFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: kSecondaryColor),
              title: const Text('Share'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.sharePdf(pdfFile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: kTertiaryColor),
              title: const Text('Share via Email'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.shareViaEmail(pdfFile, '');
              },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: kPrimaryColor),
              title: const Text('Print'),
              onTap: () async {
                Navigator.pop(context);
                await PdfService.printPdf(pdfFile);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.coursename,
              style: TextStyle(
                fontSize: 12,
                color: kOnSurfaceColor.withOpacity(0.7),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _isGeneratingPdf ? null : _generateStudentPdf,
            tooltip: 'Export Student Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: buildOne(context),
      ),
      floatingActionButton: _isGeneratingPdf
          ? const FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : null,
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
                  // Student Info Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            AppLocalizations.of(context).address,
                            snapshot.data!['address'],
                            Icons.location_on,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            AppLocalizations.of(context).father,
                            snapshot.data!['fathername'],
                            Icons.person,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            AppLocalizations.of(context).mother,
                            snapshot.data!['mothername'],
                            Icons.person,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            AppLocalizations.of(context).phone,
                            snapshot.data!['phonenumber'],
                            Icons.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: kLargePadding),

                  // Attendance Records Title
                  const Text(
                    'Attendance Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),

                  // Table Header
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryContainer,
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                    ),
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context).dato,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Expanded(
                          child: const Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
          Card(
            margin: const EdgeInsets.only(bottom: kSmallPadding),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      keys[y],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Expanded(
                    child: _buildStatusChip(snapshot[widget.courseID][keys[y]]),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kPrimaryColor),
        const SizedBox(width: kSmallPadding),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Present':
        color = kPresentColor;
        icon = Icons.check_circle;
        break;
      case 'Absent':
        color = kAbsentColor;
        icon = Icons.cancel;
        break;
      case 'Excused':
        color = kExcusedColor;
        icon = Icons.info;
        break;
      default:
        color = kOutlineColor;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSmallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
