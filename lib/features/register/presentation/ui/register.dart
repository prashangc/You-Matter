import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/focus_remover.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/register/model/register_model.dart';
import 'package:you_matter/features/register/presentation/widget/reg_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<GlobalKey<FormState>> formKeys =
      List.generate(5, (index) => GlobalKey<FormState>());
  RegisterModel registerModel = RegisterModel();
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
                "assets/mobile/register_bg.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizedBox12(),
                  Text(
                    'REGISTER A HOTEL',
                    style: kStyle18B,
                  ),
                  formCard(
                    context,
                    registerModel,
                    formKeys,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
