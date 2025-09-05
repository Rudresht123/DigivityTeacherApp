import 'package:digivity_admin_app/AdminPanel/AuthenticationMultiuser/MultiSchoolApp.dart';
import 'package:digivity_admin_app/AdminPanel/Dashboard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/OnlineClass/AddOnlineClass.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/OnlineClass/OnlineClassList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Calendar/CalendarWithEvents.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/CommunicationManagement/CommunicationIndex.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/CommunicationManagement/SendSMS/ComposeSms.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/CommunicationManagement/SendSMS/SendSmsTousers.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/ExamMarksIndex.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/ExamRemarkEntry/StudentRemarkEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/ExamRemarkEntry/StudentSearchExamRemarkEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/SearchForMarksEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/ClassWiseTotalAttendance.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/ClassWiseTotalConductedPtm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/StudentHeightWeightEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/StudentPtmEntryList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/StudentTotalAttendaceEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/ExamTotalAttendsnaceSearch.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentExamOtherEntryIndex.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentHeightWeightList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/StudentPtmSearch.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentListFormMarksEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FinanceReports.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/ClassCourseWiseFeeDefaulterReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/ClassWiseCollectionReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/ClassWiseConsolidateReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/DailyReciptConsessionReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/DayBookReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/FeeCollectionReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/FeeHeadWiseCollectionReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/MonthelyFeeCollection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FormScreens/PayModeWiseFeeCollection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/MasterUpdate/FieldUpdateStudentList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/MasterUpdate/FieldUpdateStudentListSearch.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/MasterUpdate/MasterUpdateIndex.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/MasterUpdate/RollNumberUpdation/SearchStudentListForRollNum.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/MasterUpdate/RollNumberUpdation/StudentListForUpdateRollNum.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffAttendance/StaffMarkAttendance.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/AddStaffForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffFillterForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffListScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffProfile.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/UpdateStaffProfile.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendance/StudentAttendanceFillterForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendance/StudentMarkAttendance.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/CourseWiseAttendaceReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/CourseWiseStudentAttendanceReportScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/DayWiseAttendanceReport.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/DayWiseStudentAttendanceReportScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/StaffAttendanceReportForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentAttendanceReports/StudentAttendaceReports.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentComplaint/AddStudentComplaint.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentComplaint/ComplaintList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentComplaint/FliterStudentComplaint.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentLeave/FillterStudentDataForLeave.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentLeave/StudentLeaveRecordScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/EditStudentDetails.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentBirthdayList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentDashboard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentListScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentLsitsDataForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentProfile.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/AddAssignment.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/StudentAssignmnet.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Circular/AddCircularScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Circular/CircularScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/HomeWorks/AddHomeworkPage.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/HomeWorks/StudentHomework.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/AddNoticeScreen.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/SchoolNotice.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/SchoolNews/AddSchoolNews.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/SchoolNews/SchoolNews.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/ClassWiseStudentDocumentsReports.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/ClasswiseStudentDocumentUplodedList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/StudentDocumentsIndex.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/StudentFillterFormForDocumentUploded.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/UploadStudentDocument.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/AddSyllabusPage.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/StudentSyllabus.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/UplopadImage/StaffFillterFormForImage.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/UplopadImage/StudentFiltterForm.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/UplopadImage/UploadImageListScreens/StaffUploadImageList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/UplopadImage/UploadImageListScreens/StudentUloadImageStudentList.dart';
import 'package:digivity_admin_app/AuthenticationUi/ChangeSessions.dart';
import 'package:digivity_admin_app/AuthenticationUi/LoginPageScreen.dart';
import 'package:digivity_admin_app/AuthenticationUi/OnboardingScreen.dart';
import 'package:digivity_admin_app/AuthenticationUi/SchoolCodeVerification.dart';
import 'package:digivity_admin_app/AuthenticationUi/SplashScreen.dart';
import 'package:digivity_admin_app/AuthenticationUi/TwoFactorAuthentication.dart';
import 'package:digivity_admin_app/AuthenticationUi/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final bool isLogin; // global variable

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool('isLogin') ?? false;

  runApp(const MyApp());
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      name: 'onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/schoolCodeVerification',
      name: 'schoolCodeVerification',
      builder: (context, state) => SchoolCodeVerification(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        final Map<String, dynamic> schoolData =
            state.extra as Map<String, dynamic>;
        return LoginPageScreen(schoolData: schoolData);
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => Dashboard(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => UserProfile(),
    ),
    GoRoute(
      path: '/tow-factor-auth',
      name: 'tow-factor-auth',
      builder: (context, state) => TwoFactorAuthentication(),
    ),
    GoRoute(
      path: '/sessions',
      name: 'sessions',
      builder: (context, state) => ChangeSessions(),
    ),

    //   Student Dashboard Session Start here
    GoRoute(
      path: '/student-dashboard',
      name: 'student-dashboard',
      builder: (context, state) => StudentDashboard(),
    ),
    //   Report Section Start Here
    GoRoute(
      path: '/student-list',
      name: 'student-list',
      builder: (context, state) {
        return StudentListsDataForm();
      },
    ),
    GoRoute(
      path: '/student-search',
      name: 'student-search',
      builder: (context, state) {
        return StudentListScreen();
      },
    ),
    GoRoute(
      name: 'edit-student',
      path: '/edit-student/:id',
      builder: (context, state) {
        final studentId = state.pathParameters['id']; // cast appropriately
        return EditStudentDetails(studentId: studentId);
      },
    ),
    GoRoute(
      name: 'student-profile',
      path: '/student-profile/:id',
      builder: (context, state) {
        final studentId = state.pathParameters['id']; // cast appropriately
        return StudentProfile(studentId: studentId);
      },
    ),

    //   Attendance Report Section Start Here
    GoRoute(
      name: 'student-attendance-reports',
      path: '/student-attendance-reports',
      builder: (context, state) {
        return StudentAttendaceReports();
      },
    ),
    GoRoute(
      name: 'day-wise-student-attendance-reports',
      path: '/day-wise-student-attendance-reports',
      builder: (context, state) {
        return DayWiseAttendanceReport();
      },
    ),

    GoRoute(
      name: 'daywise-student-attendance-report',
      path: '/day-wise-student-attendance-reports/:course_id/:reportdate',
      builder: (context, state) {
        final courseId = state.pathParameters['course_id'];
        final reportDate = state.pathParameters['reportdate'];

        return DayWiseStudentAttendanceReportScreen(
          courseId: courseId,
          reportdate: reportDate,
        );
      },
    ),

    GoRoute(
      name: 'course-wise-student-attendance-reports',
      path: '/course-wise-student-attendance-reports',
      builder: (context, state) {
        return CourseWiseAttendaceReport();
      },
    ),

    // Student Birthday Report
    GoRoute(
      name: 'student-birthday-reports',
      path: '/student-birthday-reports',
      builder: (context, state) {
        return StudentBirthdayList();
      },
    ),

    GoRoute(
      name: 'coursewise-student-attendance-report',
      path: '/coursewise-student-attendance-reports/:reportdate',
      builder: (context, state) {
        final reportDate = state.pathParameters['reportdate'];
        return CourseWiseStudentAttendanceReportScreen(reportdate: reportDate);
      },
    ),

    ///Staff Attendeace Report
    GoRoute(
      name: 'staff-attendance-report',
      path: '/staff-attendance-report',
      builder: (context, state) {
        return StaffAttendanceReportForm();
      },
    ),

    //   Staff Section Start Here
    GoRoute(
      name: 'add-staff',
      path: '/add-staff',
      builder: (context, state) {
        return AddStaffForm();
      },
    ),

    GoRoute(
      name: 'staff-profile',
      path: '/staff-profile/:id',
      builder: (context, state) {
        final staffid = state.pathParameters['id'];
        return Staffprofile(staffId: staffid);
      },
    ),

    GoRoute(
      name: 'update-staff-profile',
      path: '/update-staff-profile/:id',
      builder: (context, state) {
        final staffid = state.pathParameters['id'];
        return UpdateStaffProfile(staffId: staffid);
      },
    ),

    GoRoute(
      name: 'staff-list',
      path: '/staff-list',
      builder: (context, state) {
        return StaffFilterForm();
      },
    ),
    GoRoute(
      name: 'staff-search-list',
      path: '/staff-search-list',
      builder: (context, state) {
        return StaffListScreen();
      },
    ),

    GoRoute(
      name: 'finance/account-reports',
      path: '/finance/account-reports',
      builder: (context, state) {
        return FinanceReports();
      },
    ),

    GoRoute(
      name: 'fee-collection-report-form',
      path: '/fee-collection-report-form',
      builder: (context, state) {
        return FeeCollectionReport();
      },
    ),

    GoRoute(
      name: 'daybook-report',
      path: '/daybook-report',
      builder: (context, state) {
        return Daybookreport();
      },
    ),

    GoRoute(
      name: 'feehead-wise-collection-report',
      path: '/feehead-wise-collection-report',
      builder: (context, state) {
        return FeeHeadWiseCollectionReport();
      },
    ),

    GoRoute(
      name: 'paymode-wise-collection-report',
      path: '/paymode-wise-collection-report',
      builder: (context, state) {
        return PayModeWiseFeeCollection();
      },
    ),

    GoRoute(
      name: 'class-section-wise-collection-report',
      path: '/class-section-wise-collection-report',
      builder: (context, state) {
        return ClassWiseCollectionReport();
      },
    ),

    GoRoute(
      name: 'monthly-fee-collection-report',
      path: '/monthly-fee-collection-report',
      builder: (context, state) {
        return MonthelyFeeCollection();
      },
    ),

    GoRoute(
      name: 'daily-concession-report',
      path: '/daily-concession-report',
      builder: (context, state) {
        return DailyReciptConsessionReport();
      },
    ),

    GoRoute(
      name: 'classwise-consolidate-report',
      path: '/classwise-consolidate-report',
      builder: (context, state) {
        return ClassWiseConsolidateReport();
      },
    ),

    GoRoute(
      name: 'classwise-student-fee-defaulter-report',
      path: '/classwise-student-fee-defaulter-report',
      builder: (context, state) {
        return ClassCourseWiseFeeDefaulterReport();
      },
    ),

    ///Student Image Upload Routes Here
    GoRoute(
      name: 'student-upload-image',
      path: '/student-upload-image',
      builder: (context, state) {
        return StudentFillterForm();
      },
    ),

    GoRoute(
      name: 'upload-student-image-student-list',
      path: '/upload-student-image-student-list',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return StudentUloadImageStudentList(
          course: extra?['course'],
          shortByMethod: extra?['shortByMethod'],
          orderByMethod: extra?['orderByMethod'],
          selectedStatus: extra?['selectedStatus'],
        );
      },
    ),
    // Staff Photo Upload Section Routest
    GoRoute(
      name: 'staff-upload-image',
      path: '/staff-upload-image',
      builder: (context, state) {
        return StaffFillterFormForImage();
      },
    ),
    GoRoute(
      name: 'staff-image-upload-list',
      path: '/staff-image-upload-list',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return StaffUploadImageList(formData: extra);
      },
    ),

    /// Student Attendance Section Start Here
    GoRoute(
      name: 'attendance',
      path: '/attendance',
      builder: (context, state) {
        return StudentAttendanceFillterForm();
      },
    ),
    GoRoute(
      name: 'student-attendance-list',
      path: '/student-attendance-list',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentMarkAttendance(
          courseId: data['course_id'],
          selectedSortBy: data['selectedSortBy'],
          selectedDate: data['selectedDate'],
        );
      },
    ),

    /// Homework Section Routes Start Here
    GoRoute(
      name: 'upload-homework',
      path: '/upload-homework',
      builder: (context, setsate) {
        return StudentHomework();
      },
    ),
    GoRoute(
      name: 'add-homework',
      path: '/add-homework',
      builder: (context, setsate) {
        return AddHomeworkPage();
      },
    ),

    /// Student Syllabus Section Start Here
    GoRoute(
      name: 'upload-syllabus',
      path: '/upload-syllabus',
      builder: (context, setsate) {
        return Studentsyllabus();
      },
    ),
    GoRoute(
      name: 'add-syllabus',
      path: '/add-syllabus',
      builder: (context, setsate) {
        return AddSyllabusPage();
      },
    ),

    /// Assignments Section Start Here
    GoRoute(
      name: 'upload-assignment',
      path: '/upload-assignment',
      builder: (context, setsate) {
        return StudentAssignmnet();
      },
    ),

    GoRoute(
      name: 'add-assignment',
      path: '/add-assignment',
      builder: (context, setsate) {
        return Addassignment();
      },
    ),

    /// Notice Section Start Here
    GoRoute(
      name: 'upload-notice',
      path: '/upload-notice',
      builder: (context, setsate) {
        return Schoolnotice();
      },
    ),

    GoRoute(
      name: 'add-notice',
      path: '/add-notice',
      builder: (context, setsate) {
        return AddNoticeScreen();
      },
    ),

    /// NotCircularice Section Start Here
    GoRoute(
      name: 'upload-circular',
      path: '/upload-circular',
      builder: (context, setsate) {
        return Circularscreen();
      },
    ),

    GoRoute(
      name: 'add-circular',
      path: '/add-circular',
      builder: (context, setsate) {
        return Addcircularscreen();
      },
    ),

    //   Master Update Section Start Here
    GoRoute(
      name: 'master-update',
      path: '/master-update',
      builder: (context, setsate) {
        return MasterUpdateIndex();
      },
    ),

    /// Student Roll Number Update Section Start Here
    GoRoute(
      name: 'search-student-for-roll-number',
      path: '/search-student-for-roll-number',
      builder: (context, setsate) {
        return SearchStudentListForRollNum();
      },
    ),
    GoRoute(
      name: 'student-roll-num-update',
      path: '/student-roll-num-update',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentListForUpdateRollNum(
          course: data['course_id'],
          shortByMethod: data['selectedSortBy'],
          orderByMethod: data['orderByMethod'],
          selectedStatus: data['selectedStatus'],
        );
      },
    ),
    GoRoute(
      name: 'student-field-update-form-search',
      path: '/student-field-update-form-search',
      builder: (context, state) {
        return FieldUpdateStudentListSearch();
      },
    ),
    GoRoute(
      name: 'student-field-update-list',
      path: '/student-field-update-list',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return FieldUpdateStudentList(
          selectedCourseId: data['selectedCourseId'],
          shortByMethod: data['shortByMethod'],
          orderByMethod: data['orderByMethod'],
          selectedStatus: data['selectedStatus'],
          selectedField: data['selectedField'],
        );
      },
    ),

    //   user switch for multiple
    GoRoute(
      name: 'select-another-user',
      path: '/select-another-user',
      builder: (context, state) {
        return MultiSchoolApp();
      },
    ),

    //   Student Documents Upload section
    GoRoute(
      name: 'student-documents',
      path: '/student-documents',
      builder: (context, state) {
        return Studentdocumentsindex();
      },
    ),
    GoRoute(
      name: 'classwise-student-document-upload-report',
      path: '/classwise-student-document-upload-report',
      builder: (context, state) {
        return ClassWiseStudentDocumentsReports();
      },
    ),
    GoRoute(
      name: 'filter-student-upload-documents',
      path: '/filter-upload-student-documents',
      builder: (context, state) {
        return StudentFillterFormForDocumentUploded();
      },
    ),
    GoRoute(
      name: 'student-uploded-documents-list',
      path: '/student-uploded-documents-list',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ClasswiseStudentDocumentUplodedList(
          courseId: data['course_id'],
          selectedSortBy: data['selectedSortBy'],
          selectedStudentSort: data['selectedStudentSort'],
        );
      },
    ),

    GoRoute(
      name: 'student-document-upload',
      path: '/student-document-upload',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return UploadStudentDocument(
          studentName: data['studentName'],
          Course: data['course'],
          StudentId: data['studentId'],
          fatherName: data['fatherName'],
          motherName: data['motherName'],
          admissionNo: data['admissionNo'],
          imageUrl: data['imageUrl'],
        );
      },
    ),

    /// Exam Marks Entry Section Start Here
    GoRoute(
      name: 'exam-entry',
      path: '/exam-entry',
      builder: (context, state) {
        return ExamMarksIndex();
      },
    ),
    GoRoute(
      name: 'search-for-marks-entry',
      path: '/search-for-marks-entry',
      builder: (context, state) {
        return SearchForMarksEntry();
      },
    ),
    GoRoute(
      name: 'student-list-for-marks-entry',
      path: '/student-list-for-marks-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentListFormMarksEntry(
          courseId: data['courseId'],
          examtypeId: data['examtypeId'],
          examtermId: data['examtermId'],
          course: data['course'],
          assessment: data['assessment'],
          assessmentId: data['assessmentId'],
          examterm: data['examterm'],
          examtype: data['examtype'],
          Subject: data['Subject'],
          SubjectId: data['SubjectId'],
        );
      },
    ),

    /// Student Exam Remark Entry Section Routes Start Here
    GoRoute(
      name: 'search-for-remark-entry',
      path: '/search-for-remark-entry',
      builder: (context, state) {
        return StudentSearchExamRemarkEntry();
      },
    ),
    GoRoute(
      name: 'student-list-for-remark-entry',
      path: '/student-list--for-remark-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return Studentremarkentry(
          courseId: data['courseId'],
          examtermId: data['examtermId'],
          remarkEntryMode: data['remarkEntryMode'],
          course: data['course'],
          examterm: data['examterm'],
        );
      },
    ),

    /// Exam Management Other Entry Route Section Start Here
    GoRoute(
      name: 'student-exam-other-entry-search',
      path: '/student-exam-other-entry-search',
      builder: (context, state) {
        return StudentExamOtherEntryIndex();
      },
    ),

    // total Attendance Entry
    GoRoute(
      name: 'exam-total-attendance-entry',
      path: '/exam-total-attendance-entry',
      builder: (context, state) {
        return ExamTotalAttendsnaceSearch();
      },
    ),

    //   Attendance For Student
    GoRoute(
      name: 'student-total-attendance-entry',
      path: '/student-total-attendance-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentTotalAttendaceEntry(
          courseId: data['courseId'],
          examTermId: data['examTermId'],
          course: data['course'],
          examTerm: data['examTerm'],
        );
      },
    ),

    //  Class Total Attendance
    GoRoute(
      name: 'class-total-attendance-entry',
      path: '/class-total-attendance-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ClassWiseTotalAttendance(
          courseId: data['courseId'],
          examTermId: data['examTermId'],
          course: data['course'],
          examTerm: data['examTerm'],
        );
      },
    ),

    //  Student Height and Weight Routes
    GoRoute(
      name: 'student-height-weight-list-search',
      path: '/student-height-weight-list-search',
      builder: (context, state) {
        return StudentHeightWeightList();
      },
    ),
    GoRoute(
      name: 'student-height-weight-entry',
      path: '/student-height-weight-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentHeightWeightEntry(
          courseId: data['courseId'],
          examTermId: data['examTermId'],
          course: data['course'],
          examTerm: data['examTerm'],
        );
      },
    ),

    //   PTM For Student
    GoRoute(
      name: 'student-ptm-list-search',
      path: '/student-ptm-list-search',
      builder: (context, state) {
        return StudentPtmSearch();
      },
    ),
    GoRoute(
      name: 'student-total-attend-ptm-entry',
      path: '/student-total-attend-ptm-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return StudentPtmEntryList(
          courseId: data['courseId'],
          examTermId: data['examTermId'],
          course: data['course'],
          examTerm: data['examTerm'],
        );
      },
    ),
    GoRoute(
      name: 'class-total-conducted-ptm-entry',
      path: '/class-total-conducted-ptm-entry',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ClassWiseTotalConductedPtm(
          courseId: data['courseId'],
          examTermId: data['examTermId'],
          course: data['course'],
          examTerm: data['examTerm'],
        );
      },
    ),

    ///  Routes for the Communication Management
    GoRoute(
      name: 'communication-index',
      path: '/communication-index',
      builder: (context, state) {
        return CommunicationIndex();
      },
    ),
    GoRoute(
      name: 'list-for-compose-sms',
      path: '/list-for-compose-sms',
      builder: (context, state) {
        return SendSmsTousers();
      },
    ),
    GoRoute(
      name: 'compose-sms',
      path: '/compose-sms',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return ComposeSms(
          selectedCourses: List<String>.from(data['selectedCourseIds'] ?? []),
          selectedDesignations: List<int>.from(
            data['selectedDesignationIds'] ?? [],
          ),
          selectedAdminstration: List<int>.from(
            data['selectedAdminstration'] ?? [],
          ),
        );
      },
    ),

    /// Staff Attendance Section Start Here
    GoRoute(
      name: 'mark-staff-attendance',
      path: '/mark-staff-attendance',
      builder: (context, state) {
        return StaffMarkAttendance();
      },
    ),

    /// School News Section Start Here
    GoRoute(
      name: 'school-news',
      path: '/school-news',
      builder: (context, state) {
        return SchoolNews();
      },
    ),
    GoRoute(
      name: 'add-school-news',
      path: '/add-school-news',
      builder: (context, state) {
        return AddSchoolNews();
      },
    ),

    /// Calender Section Start Here
    GoRoute(
      name: 'calendar',
      path: '/calendar',
      builder: (context, state) {
        return CalendarWithEvents();
      },
    ),

    /// Student Leave Section Start Here
    GoRoute(
      name: 'student-leave',
      path: '/student-leave',
      builder: (context, state) {
        return FillterStudentDataForLeave();
      },
    ),
    GoRoute(
      name: 'student-leave-record',
      path: '/student-leave-record',
      builder: (context, state) {
        final formData = state.extra as Map<String, dynamic>?;
        return StudentLeaveRecordScreen(formData: formData);
      },
    ),

    /// Student Online Class Section Start Here
    GoRoute(
      name: 'student-online-classes',
      path: '/student-online-classes',
      builder: (context, state) {
        return OnlineClassList();
      },
    ),

    GoRoute(
      name: 'add-online-classes',
      path: '/add-online-classes',
      builder: (context, state) {
        return AddOnlineClass();
      },
    ),

    /// Student Complaint Section Start Here
    GoRoute(
      name: "student-complaint-filter",
      path: "/student-complaint-filter",
      builder: (context, state) {
        return FilterStudentComplaint();
      },
    ),
    GoRoute(
      name: "student-raised-complaint",
      path: "/student-raised-complaint",
      builder: (context, state) {
        final formdata = state.extra as Map<String, dynamic>;
        return ComplaintList(formdata: formdata);
      },
    ),

    GoRoute(
      name: "add-student-complaint",
      path: "/add-student-complaint",
      builder: (context, state) {
        return AddStudentComplaint();
      },
    ),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;

    if (isLogin && state.fullPath == '/') {
      return '/splash';
    }

    if (!isLogin &&
        state.fullPath != '/' &&
        state.fullPath != '/schoolCodeVerification' &&
        state.fullPath != '/login') {
      return '/';
    }

    return null;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
