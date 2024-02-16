import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/focus_remover.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/login/model/login_model.dart';
import 'package:you_matter/features/login/presentation/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<GlobalKey<FormState>> formKeys =
      List.generate(2, (index) => GlobalKey<FormState>());
  LoginModel model = LoginModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: GestureDetector(
        onTap: () => myFocusRemover(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
          height: maxHeight(context),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/test.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width:
                    maxWidth(context) > 600.0 ? 600.0 : maxWidth(context) * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: kStyle18B,
                    ),
                    sizedBox12(),
                    loginForm(context, model, formKeys),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
