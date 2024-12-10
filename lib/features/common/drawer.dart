import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/features/common/show_dialog.dart';
import 'package:smart_crm_app/injection_container.dart';

import '../../../../../../config/theme/colors.dart';

import '../auth/presentation/bloc/theme_cubit.dart';
import 'animated_theme.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    // final isDarkMode = themeCubit.state.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.accentColor,
              image: DecorationImage(
                opacity: 0.5,
                image: AssetImage('assets/logo/CRM.png'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              "Welcome ${sl<StorageServices>().getName()}!",
              style: const TextStyle(
                color: AppColors.cardBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            accountEmail: Text(
              '${sl<StorageServices>().getEmail()}',
              style: const TextStyle(
                color: AppColors.primaryBackground,
              ),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                // if (profile != null) {
                //   Navigator.of(context).pushNamed(AppRoutes.PROFILE);
                // }
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.primaryBackground,
                backgroundImage:
                    AssetImage('assets/icons/user.png') as ImageProvider,
              ),
            ),
            otherAccountsPictures: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    themeCubit.toggleTheme();
                  });
                },
                child: AnimatedMoonSunIcon(
                    isDarkMode: themeCubit.state.brightness == Brightness.dark),
              ),
            ],
          ),
          ListTile(
            iconColor: AppColors.accentColor,
            splashColor: AppColors.accentColor,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigator.of(context).pushNamed(AppRoutes.SETTING);
            },
          ),
          ListTile(
            iconColor: AppColors.accentColor,
            splashColor: AppColors.accentColor,
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              // Navigator.of(context).pushNamed(AppRoutes.FEEDBACK);
            },
          ),
          ListTile(
            iconColor: AppColors.accentColor,
            splashColor: AppColors.accentColor,
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              // Navigator.of(context).pushNamed(AppRoutes.ABOUT_US);
            },
          ),
          ListTile(
            iconColor: AppColors.accentColor,
            splashColor: AppColors.accentColor,
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
