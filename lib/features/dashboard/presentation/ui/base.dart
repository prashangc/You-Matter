import 'package:flutter/material.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/features/dashboard/controller/dashboard_controller.dart';

class BasePage extends StatelessWidget {
  final int currentIndex;
  final bool isTherapist;
  const BasePage(
      {super.key, required this.currentIndex, required this.isTherapist});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        initialData: currentIndex,
        stream: dashboardController.baseBloc.stateStream,
        builder: (c, s) {
          return Scaffold(
            body: dashboardController.screens(isTherapist)[s.data],
            bottomNavigationBar: SweetNavBar(
              currentIndex: 0,
              paddingBackgroundColor: ColorConstant.backgroundColor,
              items: [
                if (!isTherapist) ...{
                  SweetNavBarItem(
                    sweetBackground: ColorConstant.backgroundColor,
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.home_outlined),
                    sweetLabel: 'Home',
                  )
                },
                SweetNavBarItem(
                    sweetBackground: ColorConstant.backgroundColor,
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.chat_outlined),
                    sweetLabel: 'Chat'),
                SweetNavBarItem(
                    sweetBackground: ColorConstant.backgroundColor,
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.perm_identity_outlined),
                    sweetLabel: 'Profile'),
              ],
              onTap: (index) {
                dashboardController.baseBloc.storeData(data: index);
              },
            ),
          );
        });
  }
}
