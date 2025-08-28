import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);


    return Stack(
      children: [
        Positioned.fill(
          child: _buildBackground(uiTheme),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );

  }

  Widget _buildBackground(UiThemeProvider uiTheme) {
    final imageUrl = uiTheme.screenBackgroundImage;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/logos/bg-app.jpg', fit: BoxFit.cover);
        },
      );
    } else if (uiTheme.screenBackgroundColor != null) {
      return Container(color: uiTheme.screenBackgroundColor);
    } else {
      return Image.asset('assets/logos/bg-app.jpg', fit: BoxFit.cover);
    }
  }

}
