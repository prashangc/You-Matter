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
    print("Nabin Gurung $isTherapist");
    return StreamBuilder<dynamic>(
        initialData: currentIndex,
        stream: dashboardController.baseBloc.stateStream,
        builder: (c, s) {
          return Scaffold(
            body: dashboardController.screens(isTherapist)[s.data],
            bottomNavigationBar: SweetNavBar(
              backgroundColor: Colors.white,
              currentIndex: 0,
              paddingBackgroundColor: ColorConstant.backgroundColor,
              items: [
                if (!isTherapist) ...{
                  SweetNavBarItem(
                    sweetBackground: ColorConstant.kPrimary,
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.home_outlined),
                    sweetLabel: 'Home $isTherapist',
                  )
                },
                SweetNavBarItem(
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.chat_outlined),
                    sweetLabel: 'Chat'),
                SweetNavBarItem(
                    iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                    sweetIcon: const Icon(Icons.perm_identity_outlined),
                    sweetLabel: 'Profile'),
                if (isTherapist) ...{
                  SweetNavBarItem(
                      iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                      sweetIcon: const Icon(Icons.request_quote),
                      sweetLabel: 'Request')
                },
                if (!isTherapist) ...{
                  SweetNavBarItem(
                      iconColors: [ColorConstant.kBlack, ColorConstant.kGrey],
                      sweetIcon: const Icon(Icons.book_online),
                      sweetLabel: 'My Booking')
                },
              ],
              onTap: (index) {
                dashboardController.baseBloc.storeData(data: index);
              },
            ),
          );
        });
  }
}
