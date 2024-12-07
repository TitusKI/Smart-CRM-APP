import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../config/theme/colors.dart';
import '../bloc/verification/verification_bloc.dart';

class PinCodeFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const PinCodeFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
      },
    );
  }
}
