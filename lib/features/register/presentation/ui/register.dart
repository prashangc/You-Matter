import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/focus_remover.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/register/model/register_model.dart';
import 'package:you_matter/features/register/presentation/widget/category_sheet.dart';
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
  bool isTherapist = false;
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
                "assets/images/register.jpg",
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
                    'REGISTER AN ACCOUNT',
                    style: kStyle18B,
                  ),
                  formCard(context, registerModel, formKeys, isTherapist),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text("Are you a therapist?"),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: isTherapist,
                    onChanged: (value) async {
                      String? test = await showModalBottomSheet(
                        context: context,
                        backgroundColor: ColorConstant.backgroundColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        builder: (BuildContext ctx) {
                          return categoryBottomModelSheet(context);
                        },
                      );
                      if (test != null) {
                        setState(() {
                          isTherapist = value ?? false;
                          registerModel.therapistCategory = test;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
