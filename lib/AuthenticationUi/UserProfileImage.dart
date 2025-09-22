import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:flutter/material.dart';


class UserProfileImage extends StatefulWidget {
  final double radius;

  const UserProfileImage({super.key, this.radius = 30});

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    try {
      final url = await SharedPrefHelper.getPreferenceValue('profile_image');
      setState(() {
        imageUrl = url;
      });
    }catch(e){
      showBottomMessage(context, "${e}", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : const AssetImage('assets/logos/default_profile.png') as ImageProvider,
      backgroundColor: Colors.white,
    );
  }
}
