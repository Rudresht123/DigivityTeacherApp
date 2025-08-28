import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/CircularModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/NoticeCard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/NoticeFillterBorromSheet.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/CircularHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Circularscreen extends StatefulWidget {
  @override
  State<Circularscreen> createState() => _Circularscreen();
}

class _Circularscreen extends State<Circularscreen> {
  TextEditingController _searchCircular = TextEditingController();
  List<CircularModel> _criculars = [];
  List<CircularModel> _filterdCirculars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ferchedCircular({});
    });
  }

  Future<void> ferchedCircular(Map<String, dynamic>? bodydata) async {
    setState(() => _isLoading = true);
    try {
      final helper = Circularhelper();
      final data = await helper.getCreatedCirculars(bodydata);
      print(data);
      setState(() {
        _criculars = data;
        _filterdCirculars = data;
      });
    } catch (e) {
      print('Error fetching Circular: $e');
    }
    finally{
      _isLoading = false;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'School Circular', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(
                controller: _searchCircular,
                onChanged: (value) {
                  final query = value.toLowerCase();
                  setState(() {
                    _filterdCirculars = _criculars.where((circular) =>
                    (circular.circular ?? '').toLowerCase().contains(query) ||
                        (circular.course ?? '').toLowerCase().contains(query) ||
                        (circular.circularTitle ?? '').toLowerCase().contains(query)
                    ).toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filterdCirculars.isEmpty
                    ? const Center(child: Text('No Notice found'))
                    : ListView.builder(
                  itemCount: _filterdCirculars.length,
                  itemBuilder: (context, index) {
                    final circular = _filterdCirculars[index];
                    return Noticecard(
                      noticeId:circular.circularId,
                      course: circular.course ?? '',
                      time: circular.circularTime ?? '',
                      noticeNo:circular.circularNo ?? '',
                      noticeDate: circular.circularDate ?? '',
                      noticeTitle: circular.circularTitle ?? '',
                      noticeDescription: circular.circular ?? '',
                      submittedBy: circular.submittedBy ?? '',
                      submittedByProfile: circular.submittedByProfile ?? '',
                      attachments: circular.attachments,
                      withapp: circular.withApp,
                      withEmail: circular.withEmail,
                      withtextSms: circular.withTextSms,
                      withWebsite: circular.withWebsite,
                      authorizedBy:circular.authorizeBy,
                      noticeurls: (circular.urlLink != null && circular.urlLink!.trim().isNotEmpty)
                          ? circular.urlLink!.split('~').where((e) => e.trim().isNotEmpty).toList()
                          : <String>[],

                      onDelete: () async {
                        final helper = Circularhelper();
                        final response = await helper.deleteCirculars(circular.circularId); // delete from backend

                        if (response['result'] == 1) {
                          await ferchedCircular({}); // refresh list
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
            await ferchedCircular(filterData);
            hideLoaderDialog(context);
          }
        },
        onAdd: () {
          context.pushNamed('add-circular');
        },
        addText: "Add Circular",
      ),
    );  
  }
}
