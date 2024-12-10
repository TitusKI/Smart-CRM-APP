import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/names.dart';
import '../../config/theme/colors.dart';
import '../../core/resources/generic_state.dart';
import '../auth/presentation/bloc/sign_out_cubit.dart';
import '../auth/presentation/widgets/flutter_toast.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutCubit, GenericState>(
      listener: (context, state) {
        if (state.isSuccess) {
          print("SignOut Successfully");
          Navigator.of(context).pop(); // Dismiss the dialog
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.LOGIN,
            (Route<dynamic> route) => false,
          );
        }
        if (state.failure!.isNotEmpty) {
          toastInfo(msg: state.failure!);
        }
      },
      child: AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Cancel'),
          ),
          BlocBuilder<SignOutCubit, GenericState>(
            builder: (context, state) {
              return state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: () {
                        context.read<SignOutCubit>().signOut();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: AppColors.accentColor),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}

// Usage
void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const LogoutDialog();
    },
  );
}
