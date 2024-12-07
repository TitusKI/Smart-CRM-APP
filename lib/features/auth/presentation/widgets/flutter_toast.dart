import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/theme/colors.dart';

toastInfo({
  required String msg,
  Color backgroundColor = Colors.white,
  Color textColor = AppColors.accentColor,
  ToastGravity gravity = ToastGravity.TOP,
}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: 5,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.sp,
  );
}
