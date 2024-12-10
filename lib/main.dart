import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_crm_app/config/routes/pages.dart';
import 'package:smart_crm_app/features/auth/presentation/bloc/theme_cubit.dart';
import 'package:smart_crm_app/injection_container.dart';

Future<void> main() async {
  await initializeInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppPages appPages = AppPages();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...appPages.allBlocProvider(context),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
          builder: (context, child) => BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, theme) {
                  return MaterialApp(
                    theme: theme,
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: appPages.generateRouteSettings,
                  );
                },
              )),
    );
  }
}
