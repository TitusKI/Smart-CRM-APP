import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_crm_app/features/admin/presentation/pages/admin_dashboard.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/resources/generic_state.dart';
import '../../../auth/domain/entities/signup_entity.dart';
import '../bloc/admin_cubit.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().getAllUsers(); // Fetch users on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminCubit, GenericState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.failure != null && state.failure!.isNotEmpty) {
            return Center(child: Text("Error: ${state.failure}"));
          } else if (state.data == null || state.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final List<UserEntity> users = state.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Management",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => AppColors.accentColor.withOpacity(0.5),
                        ),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentColor,
                        ),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Role')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: users.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(
                                  Text(user.email.split('@').first)), // Mock ID
                              DataCell(Text(user.name)),
                              DataCell(Text(user.email)),
                              DataCell(Text(user.role ?? "User")),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _deleteUser(context, user.id!);
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.accentColor,
        backgroundColor: AppColors.primaryBackground,
        onPressed: () => _showUserDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDialog(BuildContext context, UserEntity? user) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            SizedBox(
              height: 4.h,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            SizedBox(
              height: 4.h,
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: "Role"),
            ),
            SizedBox(
              height: 4.h,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            SizedBox(
              height: 4.h,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: "Confirm password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.primaryBackground,
              backgroundColor: AppColors.accentColor,
            ),
            onPressed: () {
              final newUser = UserEntity(
                name: nameController.text,
                email: emailController.text,
                role: roleController.text,
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
              );

              context.read<AdminCubit>().createUser(newUser);

              Navigator.pop(context);
            },
            child: const Text(
              "Add",
            ),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<AdminCubit>().deleteUser(id);
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
