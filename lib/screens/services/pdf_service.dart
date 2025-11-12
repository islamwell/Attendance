// Platform-agnostic imports
import 'dart:io' if (dart.library.html) 'dart:html' as platform;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// Remove these web-incompatible imports
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

class PdfService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a PDF report for a specific course
  /// Returns Uint8List (bytes) which works on both web and mobile
  static Future<Uint8List> generateCourseReport({
    required String courseId,
    required String courseName,
    required String teacherName,
  }) async {
    // Fetch course data
    final courseDoc = await _firestore.collection('courses').doc(courseId).get();
    final courseData = courseDoc.data();

    if (courseData == null) {
      throw Exception('Course not found');
    }

    final List<dynamic> studentIds = courseData['students'] ?? [];

    // Fetch student data and attendance
    final List<Map<String, dynamic>> studentsData = [];

    for (String studentId in studentIds) {
      final studentDoc = await _firestore.collection('students').doc(studentId).get();
      final studentData = studentDoc.data();

      if (studentData != null) {
        // Get attendance data for this course
        final attendanceData = studentData[courseId] as Map<String, dynamic>?;

        int presentCount = 0;
        int absentCount = 0;
        int excusedCount = 0;
        int totalDays = 0;

        if (attendanceData != null) {
          attendanceData.forEach((date, status) {
            totalDays++;
            if (status == 'Present') {
              presentCount++;
            } else if (status == 'Absent') {
              absentCount++;
            } else if (status == 'Excused') {
              excusedCount++;
            }
          });
        }

        final double attendancePercentage = totalDays > 0
            ? (presentCount / totalDays) * 100
            : 0.0;

        studentsData.add({
          'name': studentData['name'] ?? 'Unknown',
          'father': studentData['father'] ?? '',
          'mother': studentData['mother'] ?? '',
          'phone': studentData['phone'] ?? '',
          'presentCount': presentCount,
          'absentCount': absentCount,
          'excusedCount': excusedCount,
          'totalDays': totalDays,
          'attendancePercentage': attendancePercentage,
        });
      }
    }

    // Sort students by name
    studentsData.sort((a, b) => a['name'].compareTo(b['name']));

    // Generate PDF
    final pdf = pw.Document();

    // Add pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            _buildHeader(courseName, teacherName),
            pw.SizedBox(height: 20),

            // Summary
            _buildSummary(studentsData),
            pw.SizedBox(height: 20),

            // Student Details Table
            _buildStudentTable(studentsData),

            // Footer
            pw.SizedBox(height: 30),
            _buildFooter(),
          ];
        },
      ),
    );

    // Return PDF bytes (works on both web and mobile)
    return await pdf.save();
  }

  /// Generate a PDF report for a specific student
  /// Returns Uint8List (bytes) which works on both web and mobile
  static Future<Uint8List> generateStudentReport({
    required String studentId,
    required String studentName,
    required String courseId,
    required String courseName,
  }) async {
    final studentDoc = await _firestore.collection('students').doc(studentId).get();
    final studentData = studentDoc.data();

    if (studentData == null) {
      throw Exception('Student not found');
    }

    // Get attendance data for this course
    final attendanceData = studentData[courseId] as Map<String, dynamic>?;

    final List<Map<String, dynamic>> attendanceRecords = [];
    int presentCount = 0;
    int absentCount = 0;
    int excusedCount = 0;

    if (attendanceData != null) {
      attendanceData.forEach((date, status) {
        attendanceRecords.add({
          'date': date,
          'status': status,
        });

        if (status == 'Present') {
          presentCount++;
        } else if (status == 'Absent') {
          absentCount++;
        } else if (status == 'Excused') {
          excusedCount++;
        }
      });
    }

    // Sort by date (descending)
    attendanceRecords.sort((a, b) => b['date'].compareTo(a['date']));

    final int totalDays = attendanceRecords.length;
    final double attendancePercentage = totalDays > 0
        ? (presentCount / totalDays) * 100
        : 0.0;

    // Generate PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            _buildStudentReportHeader(studentName, courseName),
            pw.SizedBox(height: 20),

            // Student Info
            _buildStudentInfo(studentData),
            pw.SizedBox(height: 20),

            // Attendance Summary
            _buildAttendanceSummary(
              presentCount,
              absentCount,
              excusedCount,
              totalDays,
              attendancePercentage,
            ),
            pw.SizedBox(height: 20),

            // Attendance Records
            _buildAttendanceRecords(attendanceRecords),

            // Footer
            pw.SizedBox(height: 30),
            _buildFooter(),
          ];
        },
      ),
    );

    // Return PDF bytes (works on both web and mobile)
    return await pdf.save();
  }

  // PDF Building Components

  static pw.Widget _buildHeader(String courseName, String teacherName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Attendance Report',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.deepPurple,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 2, color: PdfColors.deepPurple),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Course: $courseName',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Instructor: $teacherName',
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummary(List<Map<String, dynamic>> studentsData) {
    final int totalStudents = studentsData.length;
    final double avgAttendance = studentsData.isEmpty
        ? 0.0
        : studentsData
            .map((s) => s['attendancePercentage'] as double)
            .reduce((a, b) => a + b) / totalStudents;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Total Students', totalStudents.toString()),
          _buildSummaryItem('Avg Attendance', '${avgAttendance.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.deepPurple,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _buildStudentTable(List<Map<String, dynamic>> studentsData) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
        5: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
          children: [
            _buildTableHeader('Student Name'),
            _buildTableHeader('Present'),
            _buildTableHeader('Absent'),
            _buildTableHeader('Excused'),
            _buildTableHeader('Total'),
            _buildTableHeader('Attendance %'),
          ],
        ),
        // Data Rows
        ...studentsData.map((student) {
          return pw.TableRow(
            children: [
              _buildTableCell(student['name']),
              _buildTableCell(student['presentCount'].toString()),
              _buildTableCell(student['absentCount'].toString()),
              _buildTableCell(student['excusedCount'].toString()),
              _buildTableCell(student['totalDays'].toString()),
              _buildTableCell(
                '${student['attendancePercentage'].toStringAsFixed(1)}%',
                color: _getAttendanceColor(student['attendancePercentage']),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          color: color ?? PdfColors.black,
          fontWeight: color != null ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static PdfColor _getAttendanceColor(double percentage) {
    if (percentage >= 75.0) {
      return PdfColors.green700;
    } else if (percentage >= 50.0) {
      return PdfColors.orange700;
    } else {
      return PdfColors.red700;
    }
  }

  // Student Report Components

  static pw.Widget _buildStudentReportHeader(String studentName, String courseName) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Student Attendance Report',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.deepPurple,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 2, color: PdfColors.deepPurple),
        pw.SizedBox(height: 12),
        pw.Text(
          'Student: $studentName',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Course: $courseName',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Report Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  static pw.Widget _buildStudentInfo(Map<String, dynamic> studentData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Contact Information',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text("Father's Name: ${studentData['father'] ?? 'N/A'}"),
          pw.Text("Mother's Name: ${studentData['mother'] ?? 'N/A'}"),
          pw.Text('Phone: ${studentData['phone'] ?? 'N/A'}'),
        ],
      ),
    );
  }

  static pw.Widget _buildAttendanceSummary(
    int presentCount,
    int absentCount,
    int excusedCount,
    int totalDays,
    double attendancePercentage,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.deepPurple, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Attendance Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.deepPurple,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryBox('Present', presentCount, PdfColors.green700),
              _buildSummaryBox('Absent', absentCount, PdfColors.red700),
              _buildSummaryBox('Excused', excusedCount, PdfColors.orange700),
              _buildSummaryBox('Total Days', totalDays, PdfColors.blue700),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Center(
            child: pw.Text(
              'Attendance Rate: ${attendancePercentage.toStringAsFixed(1)}%',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: _getAttendanceColor(attendancePercentage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryBox(String label, int value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          value.toString(),
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  static pw.Widget _buildAttendanceRecords(List<Map<String, dynamic>> records) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Attendance Records',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
              children: [
                _buildTableHeader('Date'),
                _buildTableHeader('Status'),
              ],
            ),
            // Records (limit to 20 most recent)
            ...records.take(20).map((record) {
              final status = record['status'] as String;
              final color = status == 'Present'
                  ? PdfColors.green700
                  : status == 'Absent'
                      ? PdfColors.red700
                      : PdfColors.orange700;

              return pw.TableRow(
                children: [
                  _buildTableCell(record['date']),
                  _buildTableCell(status, color: color),
                ],
              );
            }).toList(),
          ],
        ),
        if (records.length > 20)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Text(
              'Showing 20 most recent records out of ${records.length} total',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        pw.Text(
          'Generated by Attendance Tracker App',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
        pw.Text(
          '© ${DateTime.now().year} - Confidential',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ],
    );
  }

  // Sharing Methods (Web and Mobile compatible)

  /// Share PDF via email (opens system share dialog)
  static Future<void> shareViaEmail(Uint8List pdfBytes, String recipientEmail) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'attendance_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  /// Generic share (shows system share sheet on mobile, download on web)
  static Future<void> sharePdf(Uint8List pdfBytes) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'attendance_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  /// Print PDF (works on both web and mobile)
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  /// Preview PDF before sharing (opens print preview)
  static Future<void> previewPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}
