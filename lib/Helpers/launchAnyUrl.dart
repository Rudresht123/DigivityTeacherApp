import 'package:url_launcher/url_launcher.dart';

Future<void> openFile(String url) async {
  final uri = Uri.parse(url);
  try {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  } catch (e) {
    print("❌ Exception: $e");
  }
}
