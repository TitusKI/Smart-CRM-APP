import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../config/theme/colors.dart';
import '../bloc/verification/verification_bloc.dart';

AppBar buildAppBar(String type) {
  return AppBar(
    backgroundColor: Colors.transparent,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppColors.secondaryColor,
        // height defines the thickness of the line
        height: 1.0,
      ),
    ),
    title: Center(
      child: Text(type,
          style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal)),
    ),
  );
}

class NoInternetConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetConnectionWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            color:
                Colors.grey, // You can use AppColors.secondaryColor if defined
            size: 60.0,
          ),
          const SizedBox(height: 12.0),
          const Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Use AppColors.secondaryColor if defined
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Please check your connection and try again.",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors
                  .black54, // You can adjust the opacity or color as needed
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.blue, // Use AppColors.primaryColor if defined
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
            child: const Text(
              "Try Again",
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBarLarge(String type,
    {List<Widget> actions = const [], Widget? leading}) {
  return AppBar(
    centerTitle: true,
    leading: leading,
    iconTheme: const IconThemeData(color: AppColors.primaryBackground),
    backgroundColor: AppColors.secondaryColor,
    flexibleSpace: Container(
        // decoration: const BoxDecoration(
        //   // gradient: LinearGradient(
        //   //   colors: [
        //   //     AppColors.secondaryColor, // Medium Persian Blue
        //   //     AppColors.accentColor, // Vivid Cerulean
        //   //   ],
        //   //   begin: Alignment.topLeft,
        //   //   end: Alignment.bottomRight,
        //   // ),
        // ),
        ),
    actions: actions,
    // systemOverlayStyle:
    //     const SystemUiOverlayStyle(statusBarColor: AppColors.secondaryColor),
    toolbarHeight: 50.0,
    // backgroundColor: AppColors.secondaryColor,
    elevation: 10,
    // backgroundColor: Colors.transparent,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       AppColors.secondaryColor, // Medium Persian Blue
        //       AppColors.accentColor, // Vivid Cerulean
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        // height defines the thickness of the line
        height: 1.0,
      ),
    ),
    title: Center(
      child: Text(
        type,
        style: TextStyle(
          color: AppColors.primaryBackground,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

//Need Context for accesssing Bloc
Widget buildThirdPartyLogin(BuildContext context, void Function()? func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h, bottom: 10.h),
      width: 325.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(15.w),
        border: Border.all(color: AppColors.cardColor),
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppColors.primaryBackground, shape: BoxShape.circle),
            child: Image.asset(
              "assets/icons/google.png",
              //color: AppColors.primaryBackground,
            ),
          ),
          SizedBox(
            width: 20.w,
          ), // Assuming this builds the Google icon

          Center(
            child: Text(
              "Continue with Google",
              style: TextStyle(
                color: AppColors.primaryBackground,
                fontWeight: FontWeight.w100,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget reusableText(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.h),
    child: Text(
      text,
      style: TextStyle(
        color: AppColors.secondaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
    ),
  );
}

Widget forgotPassword(void Function()? forgfunc) {
  return GestureDetector(
    onTap: forgfunc,
    child: Text(
      "Forgot password?",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.accentColor,
        fontSize: 12.sp,
      ),
    ),
  );
}

Widget buildLogInAndRegButton(
    String buttonName, bool isButtonEnabled, void Function()? func) {
  return GestureDetector(
    onTap: isButtonEnabled ? func : null,
    child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
            width: 325.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: isButtonEnabled == true
                    ? AppColors.accentColor
                    : AppColors.primarySecondaryText,
                borderRadius: BorderRadius.circular(15.w),
                border: Border.all(
                    color: isButtonEnabled == true
                        ? Colors.transparent
                        : AppColors.primarySecondaryText),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                    color: Colors.grey.withOpacity(0.1),
                  )
                ]),
            child: Center(
              child: Text(
                buttonName,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primaryBackground),
              ),
            )),
      ],
    ),
  );
}

Widget buildPinCodeField(
    BuildContext context, String? title, TextEditingController controller) {
  return PinCodeTextField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    appContext: context,
    length: 6,
    animationType: AnimationType.fade,
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 40,
      activeFillColor: Colors.white,
      inactiveFillColor: Colors.white,
      selectedFillColor: Colors.white,
      activeColor: AppColors.secondaryColor,
      inactiveColor: Colors.grey,
      selectedColor: AppColors.secondaryColor,
    ),
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: Colors.blue.shade50,
    enableActiveFill: true,
    onChanged: (value) {
      context.read<VerificationBloc>().add(CodeChanged(value));
      // context.read<VerificationBloc>().add(CodeChanged(value));
    },
    // onCompleted: (value) {
    //   context.read<VerificationBloc>().add(SubmitCode(code: value));
    //   context.read<VerificationBloc>().add(CodeChanged(value));
    //   title == ""
    //       ? Navigator.of(context).pushNamed("/reset_successful")
    //       : Navigator.of(context).pushNamed("/create_profile");
    //   //  context.read<VerificationBloc>().add(SubmitCode(value));
    // },
  );
}
