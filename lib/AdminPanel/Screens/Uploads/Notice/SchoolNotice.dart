import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/NoticeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/NoticeCard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/NoticeFillterBorromSheet.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/NoticeHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Schoolnotice extends StatefulWidget {
  @override
  State<Schoolnotice> createState() => _Schoolnotice();
}

class _Schoolnotice extends State<Schoolnotice> {
  TextEditingController _searchNotices = TextEditingController();
  List<NoticeModel> _notices = [];
  List<NoticeModel> _filteredNotices = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchedNotice({});
    });
  }

  Future<void> fetchedNotice(Map<String, dynamic>? formdata) async {
    setState(() => _isLoading = true);
    try {
      final helper = Noticehelper();
      final data = await helper.getCreatedNotice(formdata);
      setState(() {
        _notices = data;
        _filteredNotices = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Notice: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'School Notice', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(
                controller: _searchNotices,
                onChanged: (value) {
                  final query = value.toLowerCase();
                  setState(() {
                    _filteredNotices = _notices
                        .where(
                          (notice) =>
                              (notice.noticeTitle ?? '').toLowerCase().contains(
                                query,
                              ) ||
                              (notice.course ?? '').toLowerCase().contains(
                                query,
                              ) ||
                              (notice.notice ?? '').toLowerCase().contains(
                                query,
                              ),
                        )
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredNotices.isEmpty
                    ? const Center(child: Text('No Notice found'))
                    : ListView.builder(
                        itemCount: _filteredNotices.length,
                        itemBuilder: (context, index) {
                          final notice = _filteredNotices[index];

                          return Noticecard(
                            noticeId: notice.noticeId,
                            course: notice.course ?? '',
                            time: notice.noticeTime ?? '',
                            noticeNo: notice.noticeNo ?? '',
                            noticeDate: notice.noticeDate ?? '',
                            noticeTitle: notice.noticeTitle ?? '',
                            noticeDescription: notice.notice ?? '',
                            submittedBy: notice.submittedBy ?? '',
                            submittedByProfile: notice.submittedByProfile ?? '',
                            attachments: notice.attachments,
                            withapp: notice.withApp,
                            withEmail: notice.withEmail,
                            withtextSms: notice.withTextSms,
                            withWebsite: notice.withWebsite,
                            authorizedBy: notice.authorizeBy,
                            noticeurls:
                                (notice.urlLink != null &&
                                    notice.urlLink!.trim().isNotEmpty)
                                ? notice.urlLink!
                                      .split('~')
                                      .where((e) => e.trim().isNotEmpty)
                                      .toList()
                                : <String>[],

                            onDelete: () async {
                              final helper = Noticehelper();
                              final response = await helper.deleteNotice(
                                notice.noticeId,
                              ); // delete from backend

                              if (response['result'] == 1) {
                                await fetchedNotice({}); // refresh list
                              }

                              return response;
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomSheetForUploads(
        onFilter: () async {
          final filterData = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => NoticeFilterBottomSheet(),
          );

          if (filterData != null) {
            showLoaderDialog(context);
            await fetchedNotice(filterData);
            hideLoaderDialog(context);
          }
        },
        onAdd: () {
          context.pushNamed('add-notice');
        },
        addText: "Add Notice",
      ),
    );
  }
}
