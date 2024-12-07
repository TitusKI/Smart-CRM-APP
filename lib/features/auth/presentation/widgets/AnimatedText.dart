import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../bloc/animation/animation_bloc.dart';

Widget animatedTextScreen() {
  return BlocBuilder<AnimationBloc, AnimationState>(
    builder: (context, state) {
      double position = -305.0;

      if (state is AnimationMoving) {
        position = state.position;
      }

      return Center(
        child: SizedBox(
          height: 40.h,
          width: 300.w,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 20),
                curve: Curves.linearToEaseOut,
                right: position,
                top: 0.0,
                child: const Text(
                  'Welcome To Smart CRM',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: AppColors.accentColor),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
