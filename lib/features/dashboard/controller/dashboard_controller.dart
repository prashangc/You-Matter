import 'package:flutter/material.dart';
import 'package:you_matter/features/chat/presentation/ui/chat_screen.dart';
import 'package:you_matter/features/home/presentation/ui/home_screen.dart';
import 'package:you_matter/features/my_booking/presentation/ui/my_booking_screen.dart';
import 'package:you_matter/features/profile/presentation/ui/profile_screen.dart';
import 'package:you_matter/features/request/presentation/ui/request_screen.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class DashboardController {
  List<Widget> screens(bool isTherapist) => [
        if (!isTherapist) ...{const HomeScreen()},
        const ChatScreen(
          chatId: '',
        ),
        const ProfileScreen(),
        if (isTherapist) ...{const RequestScreen()},
        if (!isTherapist) ...{const MyBookings()},
      ];
  StateHandlerBloc baseBloc = StateHandlerBloc();
}

DashboardController dashboardController = DashboardController();
