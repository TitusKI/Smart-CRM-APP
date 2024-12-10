import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/config/routes/names.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/core/resources/generic_state.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/deactivate_account.dart';

import 'package:smart_crm_app/injection_container.dart';

import '../../../config/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirm Account Deletion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          BlocBuilder<DeactivateMyAccount, GenericState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<DeactivateMyAccount>().deleteAccount();
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.LOGIN); // Navigate to sign-in
                  // Add account deletion logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child:
                    const Text("Delete", style: TextStyle(color: Colors.white)),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.accentColor,
                    child: Text(
                      sl<StorageServices>().getName()![0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sl<StorageServices>().getName()!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sl<StorageServices>().getEmail()!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Settings Options
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined,
                      color: AppColors.secondaryColor),
                  title: const Text(
                    "View Account",
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Add logic to navigate to account details page
                  },
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                  color: AppColors.hintText,
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  onTap: () => _confirmDeleteAccount(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
