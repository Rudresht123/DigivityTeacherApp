import 'package:flutter/material.dart';

class PopupNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final double popupSize;

  const PopupNetworkImage({
    super.key,
    required this.imageUrl,
    this.radius = 30,
    this.popupSize = 400,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: "Image Preview",
          pageBuilder: (_, __, ___) {
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: popupSize,
                        height: popupSize,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
