import 'package:digivity_admin_app/AdminPanel/Components/DeleteConfirmationDialog.dart';
import 'package:digivity_admin_app/AdminPanel/Models/OnlineClassModel/OnlineClassDetails.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineClassCard extends StatelessWidget {
  final OnlineClassDetails onlineClass;
  final Future<Map<String, dynamic>> Function()? onDelete;

  const OnlineClassCard({Key? key, required this.onlineClass, this.onDelete})
    : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject
          Text(
            onlineClass.subjectName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Teacher
          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.teal),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  onlineClass.staffName,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.orange),
              const SizedBox(width: 6),
              Text(
                onlineClass.onlineClassTiming,
                style: TextStyle(color: Colors.blueGrey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Period Duration
          Row(
            children: [
              const Icon(Icons.timer, size: 18, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(
                "${onlineClass.periodTime} min",
                style: TextStyle(color: Colors.blueGrey.shade700),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit
              Expanded(
                child: CustomBlueButton(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  text: "Edit",
                  icon: Icons.edit,
                  onPressed: () {
                    try {
                      context.pushNamed(
                        "edit-online-classes",
                        extra: onlineClass,
                      );
                    } catch (e) {
                      showBottomMessage(context, "${e}", true);
                    }
                  },
                  bgColour: Colors.amber.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomBlueButton(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  text: "Delete",
                  icon: Icons.delete,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => DeleteConfirmationDialog(
                        message: "Are you sure you want to delete this item?",
                        onConfirm: () async {
                          Navigator.pop(context);
                          if (onDelete != null) {
                            showLoaderDialog(context);
                            try {
                              final response = await onDelete!();
                              showBottomMessage(
                                context,
                                response['message'],
                                response['result'] != 1,
                              );
                            } catch (e) {
                              showBottomMessage(context, "${e}", true);
                            } finally {
                              hideLoaderDialog(context);
                            }
                          }
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  bgColour: Colors.red.shade400,
                ),
              ),

              // Delete
              const SizedBox(width: 8),
              Expanded(
                child: CustomBlueButton(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  text: "Join",
                  icon: Icons.play_circle,
                  onPressed: () {},
                  bgColour: Colors.green.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
