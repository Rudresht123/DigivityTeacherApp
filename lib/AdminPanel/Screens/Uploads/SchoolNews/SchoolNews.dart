import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/SchoolNews/SchoolNewsCard.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SchoolNewsModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/UploadsDocumentsHelpers/SchoolNewsHelper.dart';

class SchoolNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SchoolNewsState();
}

class _SchoolNewsState extends State<SchoolNews> {
  List<SchoolNewsModel> _schoolNews = [];
  List<SchoolNewsModel> _filteredSchoolNews = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCreatedSchoolNews();
    _searchController.addListener(_filterNews);
  }

  void _filterNews() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSchoolNews = _schoolNews.where((news) {
        return news.newTitleSubject?.toLowerCase().contains(query) == true ||
            news.newsDescription?.toLowerCase().contains(query) == true;
      }).toList();
    });
  }

  Future<void> _getCreatedSchoolNews() async {
    setState(() => _isLoading = true);
    try {
      final response = await SchoolNewsHelper().getCreateSchoolNews({});
      if (response is List) {
        setState(() {
          _schoolNews = response;
          _filteredSchoolNews = response;
        });
      } else {
        showBottomMessage(context, "Unexpected response from server", true);
      }
    } catch (e) {
      showBottomMessage(context, "Error fetching news: $e", true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "School News", routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(controller: _searchController),
              SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredSchoolNews.isEmpty
                    ? const Center(child: Text('No News found'))
                    : ListView.builder(
                        itemCount: _filteredSchoolNews.length,
                        itemBuilder: (context, index) {
                          final news = _filteredSchoolNews[index];
                          return SchoolNewsCard(
                            newsId: news.newsId,
                            newsFor: news.newsFor,
                            time: news.newsTime,
                            newsDate: news.newsDate ?? '',
                            newsTitle: news.newTitleSubject ?? '',
                            newsDescription: news.newsDescription ?? '',
                            submittedBy: news.submittedBy ?? '',
                            submittedByProfile: news.submittedByProfile ?? '',
                            attachments: news.attachments,
                            withApp: news.showApp,
                            withEmail: news.showEmail,
                            withTextSms: news.showTextSms,
                            withWebsite: news.showWebsite,
                            authorizedBy: news.newsWroteBy,
                            newsUrls: (news.urlLink != null &&
                                news.urlLink!.trim().isNotEmpty)
                                ? news.urlLink!
                                .split('~')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList()
                                : [],
                            onDelete: () async {
                              final helper = SchoolNewsHelper();
                              final response = await helper.deleteSchoolNews(
                                  news.newsId);
                              if (response['result'] == 1) {
                                await _getCreatedSchoolNews(); // refresh list after delete
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
