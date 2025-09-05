import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentBirthdayReportModel.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Badge.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/DateChangeComponent.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/Reports/StudentBirthdayReport.dart';
import 'package:digivity_admin_app/Helpers/launchAnyUrl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBirthdayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudentBirthdayListState();
  }
}

class _StudentBirthdayListState extends State<StudentBirthdayList> {
  DateTime selectedDate = DateTime.now();
  GlobalKey _formkey = GlobalKey<FormState>();
  List<StudentBirthdayReportModel>? studentBirthdayData;
  String? course;
  @override
  void initState() {
    super.initState();
    if (course != null) {
      final formdata = {
        "course": "",
        "birth_day_date": DateFormat("dd-MM-yyyy").format(selectedDate),
      };
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getStudentBirthdayData(formdata);
      });
    }
  }

  Future<void> getStudentBirthdayData(Map<String, dynamic> formdata) async {
    showLoaderDialog(context);
    try {
      final response = await StudentBirthdayReport().getStudentBirthdayData(
        formdata,
      );
      studentBirthdayData = response;
      setState(() {});
    } catch (e) {
      print("${e}");
      showBottomMessage(context, "${e}", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Today Students Birthday List",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    /// Grade/Class dropdown (your existing CourseComponent)
                    CourseComponent(
                      onChanged: (value) async {
                        course = value;
                        final formdata = {
                          "course": course,
                          "birth_day_date": DateFormat(
                            "dd-MM-yyyy",
                          ).format(selectedDate),
                        };
                        await getStudentBirthdayData(formdata);
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Date navigation
                    DateChangeComonent(
                      selectedDate: selectedDate,
                      onDateChanged: (newDate) async {
                        setState(() {
                          selectedDate = newDate;
                        });
                        final formdata = {
                          "course": course,
                          "birth_day_date": DateFormat(
                            "dd-MM-yyyy",
                          ).format(selectedDate),
                        };
                        await getStudentBirthdayData(formdata);
                      },
                    ),

                    const SizedBox(height: 20),
                    Divider(),
                  ],
                ),
              ),
            ),

            //   Birthday Template Card Section
            CardContainer(
              child: studentBirthdayData == null
                  ? Center(child: CircularProgressIndicator()) // still loading
                  : studentBirthdayData!.isEmpty
                  ? Center(
                      child: Text(
                        "Record Not Found !!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Column(
                      children: studentBirthdayData!.map((student) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                /// Student Profile Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: PopupNetworkImage(
                                    imageUrl: student.profileImage ?? '',
                                  ),
                                ),

                                SizedBox(width: 12),

                                /// Student Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.studentName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        student.course ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        "Birthday: ${student.dob!}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BadgeScreen(
                                      text: student.birthdayNo ?? '',
                                      color: Colors.green,
                                      fontSize: 10,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 10,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            try {
                                              final imageUrl =
                                                  await StudentBirthdayReport()
                                                      .openStudentBirthdayCard(
                                                        student.dob!,
                                                        student.studentId,
                                                      );

                                              final phoneNumber = student
                                                  .contactNo!
                                                  .replaceAll(
                                                    RegExp(r'\D'),
                                                    '',
                                                  ); // keep only digits
                                              final studentName =
                                                  student.studentName;
                                              final message =
                                                  "Happy Birthday, $studentName! \n"
                                                  "Wishing you a day full of joy, laughter, and wonderful memories.\n"
                                                  "Check out your special birthday card here: $imageUrl\n"
                                                  "Have an amazing year ahead!";

                                              // Only encode the message
                                              final encodedMessage =
                                                  Uri.encodeComponent(message);
                                              // Construct WhatsApp link
                                              final whatsappUrl = Uri.parse(
                                                "https://wa.me/$phoneNumber?text=$encodedMessage",
                                              );
                                              if (await canLaunchUrl(
                                                whatsappUrl,
                                              )) {
                                                await launchUrl(whatsappUrl);
                                              } else {
                                                showBottomMessage(
                                                  context,
                                                  "Could not open WhatsApp",
                                                  true,
                                                );
                                              }
                                            } catch (e) {
                                              showBottomMessage(
                                                context,
                                                "$e",
                                                true,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons
                                                .card_giftcard, // the icon itself
                                            color: Colors.pink,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                /// Birthday Card Link Icon
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
