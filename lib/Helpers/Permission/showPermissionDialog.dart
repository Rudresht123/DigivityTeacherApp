import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> showPermissionDialog(
    BuildContext context, String title, String message) async {
  return await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Permission Dialog",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink(); // placeholder
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curvedValue = Curves.easeOutBack.transform(anim1.value);
      return Transform.scale(
        scale: curvedValue,
        child: Opacity(
          opacity: anim1.value,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Dialog Card
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).pop(false),
                              icon: const Icon(Icons.cancel,
                                  color: Colors.black87, size: 20),
                              label: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black87),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                minimumSize: const Size(120, 48),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                Navigator.of(context).pop(true);
                                await openAppSettings();
                              },
                              icon: const Icon(Icons.settings,
                                  color: Colors.white, size: 20),
                              label: const Text(
                                "Open Settings",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                minimumSize: const Size(140, 48),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Top Circular Icon
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ) ?? false;
}
