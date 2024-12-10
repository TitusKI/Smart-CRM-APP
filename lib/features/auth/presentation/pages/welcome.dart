import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes/names.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/constants/constant.dart';
import '../../../../injection_container.dart';
import '../../data/services/local/storage_services.dart';
import '../bloc/welcome/welcome_bloc.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeBloc(),
      child: Container(
        child: Scaffold(
          body: BlocBuilder<WelcomeBloc, WelcomeState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      state.page = index;
                      BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                    },
                    children: [
                      _page(
                          1,
                          context,
                          'Next',
                          "Welcome to Smart CRM",
                          "Streamline your customer and manage leads effortlessly with Smart CRM.",
                          "assets/welcome/welcome1.png"),
                      _page(
                          2,
                          context,
                          'Next',
                          "Track & Optimize",
                          "Monitor contact interactions, track performance, and optimize productivity.",
                          "assets/welcome/welcome2.png"),
                      _page(
                          3,
                          context,
                          'Get Started',
                          "Grow Your Business",
                          "Take your business to the next level with our all-in-one CRM platform.",
                          "assets/welcome/welcome3.png"),
                    ],
                  ),
                  Positioned(
                    bottom: 50.h,
                    child: DotsIndicator(
                      position: state.page,
                      dotsCount: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      decorator: DotsDecorator(
                          activeColor: AppColors.accentColor,
                          color: AppColors.cardBackground,
                          size: const Size.square(8.0),
                          activeSize: const Size(15.0, 8.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _page(int index, BuildContext context, String buttonName, String title,
      String subtitle, String imagePath) {
    return Column(
      children: [
        SizedBox(
          width: 345.w,
          height: 345.w,
          child: Image.asset(
            imagePath,
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
            child: Text(
          title,
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        )),
        Container(
          width: 375.w,
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (index < 3) {
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn);
            } else {
              sl<StorageServices>()
                  .setBool(AppConstant.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
              print(
                  "The value is: ${sl<StorageServices>().getDeviceFirstOpen()}");
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 100.h, left: 25.w, right: 25.w),
            width: 325.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.all(Radius.circular(15.w)),
            ),
            child: Center(
              child: Text(
                buttonName,
                style: TextStyle(
                  color: AppColors.primaryBackground,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
