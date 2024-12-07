import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/names.dart';
import '../../../../config/theme/colors.dart';
import '../bloc/verification/verification_bloc.dart';
import '../widgets/build_pin_code_field.dart';
import '../widgets/common_widgets.dart';

class SignUpVerification extends StatefulWidget {
  final String? title;

  const SignUpVerification({super.key, this.title});

  @override
  State<SignUpVerification> createState() => _SignUpVerificationState();
}

class _SignUpVerificationState extends State<SignUpVerification> {
  late VerificationBloc _verificationBloc;
  final TextEditingController _pinCodeController = TextEditingController();
  final String? title = "Sign up Verification";
  late String? email;
  @override
  void initState() {
    super.initState();
    // Initialize email with a default value
    email = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificationBloc = BlocProvider.of<VerificationBloc>(context);
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args == null) {
      print("Email is not sent");
    } else {
      email = args;
    }
    // setState(() {
    //   email = args;
    // });
  }

  @override
  void dispose() {
    _verificationBloc.add(ResetCode());
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarLarge(title!),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            reusableText(
                "Please Enter the 6 digit \nverification code sent \nto your email"),
            const SizedBox(
              height: 35,
            ),
            Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(8.0),
                child: BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    if (state is VerificationFailure) {
                      return Center(
                          child: Text('Error: ${state.error}',
                              style: const TextStyle(color: Colors.red)));
                    }
                    if (state is VerificationSuccess) {
                      // Navigate to the next page after successful verification
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                        return;
                      });
                    }
                    return PinCodeFieldWidget(controller: _pinCodeController);
                  },
                )),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  reusableText("Didn't receive code?"),
                  GestureDetector(
                    child: const Center(
                      child: Text(
                        'Resend Now',
                        style: TextStyle(
                            color: AppColors.accentColor, fontSize: 15),
                      ),
                    ),
                    onTap: () {
                      _verificationBloc.add(ResendCode(email!));
                    },
                  )
                ],
              ),
            ),
            BlocBuilder<VerificationBloc, VerificationState>(
              builder: (context, state) {
                bool isButtonEnabled = state is VerificationCodeValid;
                return state is VerificationLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildLogInAndRegButton("Verify", isButtonEnabled, () {
                        // final code = (state as VerificationCodeValid).code;
                        context.read<VerificationBloc>().add(SubmitCode(
                            code: int.parse(_pinCodeController.text),
                            email: email));
                        print("No error");
                        print("Email sent is  $email");
                        print("code sent is ${_pinCodeController.text}");

                        // context.read<VerificationBloc>().add(CodeChanged(code));
                      });
              },
            )
          ],
        ),
      ),
    );
  }
}
