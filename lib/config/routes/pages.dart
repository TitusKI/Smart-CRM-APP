import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_crm_app/features/admin/presentation/bloc/admin_cubit.dart';
import 'package:smart_crm_app/config/routes/names.dart';
import 'package:smart_crm_app/core/constants/exports.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/deactivate_account.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/welcome/welcome_bloc.dart';
import 'package:smart_crm_app/features/auth/presentation/pages/reset_screen.dart';
import 'package:smart_crm_app/features/auth/presentation/pages/sign_up.dart';
import 'package:smart_crm_app/features/contacts/presentation/bloc/contact_cubit.dart';
import 'package:smart_crm_app/features/leads/presentation/bloc/leads_cubit.dart';
import 'package:smart_crm_app/features/notifications/presentation/bloc/notification_cubit.dart';
import '../../features/auth/presentation/bloc/animation/animation_bloc.dart';
import '../../features/auth/presentation/bloc/sign_out_cubit.dart';
import '../../features/auth/presentation/bloc/toogle_password/toggle_password_bloc.dart';
import '../../features/auth/presentation/bloc/verification/verification_bloc.dart';
import '../../features/auth/presentation/pages/sign_in.dart';
import '../../features/auth/presentation/pages/verification_code.dart';
import '../../features/auth/presentation/pages/welcome.dart';
import '../../features/common/bottom_navigation/bottom_navigation_bloc.dart';
import '../../features/common/navigation.dart';
import '../../features/dashboard/presentation/bloc/dashboard_cubit.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../injection_container.dart';

class AppPages {
  List<PageEntity> routes() {
    return [
      PageEntity(
          route: AppRoutes.WELCOME,
          page: const Welcome(),
          bloc: BlocProvider(create: (_) => WelcomeBloc())), // Welcome Page
      PageEntity(
          route: AppRoutes.LOGIN,
          page: const SignIn(),
          bloc: BlocProvider(create: (_) => SignInBloc())),
      // Sign In Page
      PageEntity(
          route: AppRoutes.SIGNUP,
          page: const SignUp(),
          bloc: BlocProvider(create: (_) => SignUpBloc())),
      PageEntity(
          route: AppRoutes.RESET_PASSWORD,
          page: const ResetScreen(),
          bloc: BlocProvider(create: (_) => ResetPasswordBloc())),
      PageEntity(
          route: AppRoutes.SIGN_UP_VERIFICATION,
          page: const SignUpVerification(),
          bloc: BlocProvider(
            create: (_) => sl<VerificationBloc>(),
          )),
      PageEntity(
          route: AppRoutes.MAIN,
          page: const MyHomePage(),
          bloc: BlocProvider(create: (_) => sl<BottomNavigationBloc>())),
      PageEntity(
        route: AppRoutes.DASHBOARD,
        page: const DashboardScreen(),
        bloc: BlocProvider(
            create: (_) => sl<DashboardCubit>()..fetchDashboardData()),
      ),
      PageEntity(bloc: BlocProvider(create: (_) => ContactCubit())),
      PageEntity(bloc: BlocProvider(create: (_) => LeadCubit())),
      PageEntity(bloc: BlocProvider(create: (_) => NotificationCubit())),
      PageEntity(bloc: BlocProvider(create: (_) => DeactivateMyAccount())),
      PageEntity(bloc: BlocProvider(create: (_) => AdminCubit())),

      // Home Page
      PageEntity(
          bloc: BlocProvider(
        create: (_) => TogglePasswordBloc(),
      )),
      PageEntity(
          bloc: BlocProvider(
        create: (_) => SignOutCubit(),
      )),
      PageEntity(
          bloc: BlocProvider(
        create: (_) => AnimationBloc(),
      )),
    ];
  }

  List<dynamic> allBlocProvider(BuildContext context) {
    List<dynamic> blocProviders = <dynamic>[];
    for (var bloc in routes()) {
      if (bloc.bloc != null) {
        blocProviders.add(bloc.bloc);
      }
    }
    return blocProviders;
  }

  MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    print('GenerateRouteSettings');
    if (settings.name != null) {
      // check for route name matching when navigator gets triggered
      var result = routes().where((element) => element.route == settings.name);
      if (result.isNotEmpty) {
        print("first log");
        print(result.first.route);
        print(result.indexed);
        bool deviceFirstOpen = sl<StorageServices>().getDeviceFirstOpen();
        if (result.first.route == AppRoutes.WELCOME && deviceFirstOpen) {
          bool getIsLoggedIn = sl<StorageServices>().getIsLoggedIn();
          if (getIsLoggedIn) {
            print("is logged in");
            return MaterialPageRoute(
                builder: (_) => const MyHomePage(), settings: settings);
          }
          return MaterialPageRoute(
              builder: (_) => const SignIn(), settings: settings);
        }
        return MaterialPageRoute(
            builder: (_) => result.first.page!, settings: settings);
      }
    }
    print("Invalid route name: ${settings.name}");
    return MaterialPageRoute(
        builder: (_) => const Welcome(), settings: settings);
  }
}

class PageEntity {
  String? route;
  Widget? page;
  dynamic bloc;
  PageEntity({this.route, this.page, this.bloc});
}
