import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';

class FeereportHtmlshowScreen extends StatefulWidget {
  final String HtmlViewData;
  final String appbartext;

  const FeereportHtmlshowScreen({
    Key? key,
    required this.HtmlViewData,
    required this.appbartext,
  }) : super(key: key);

  @override
  State<FeereportHtmlshowScreen> createState() => _FeereportHtmlshowScreen();
}

class _FeereportHtmlshowScreen extends State<FeereportHtmlshowScreen> {
  bool isLoading = true;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _setupWebView();
  }

  void _setupWebView() {
    final uri = Uri.dataFromString(
      widget.HtmlViewData,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: widget.appbartext,
          routeName: "back",
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController),
    );
  }
}
