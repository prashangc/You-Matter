import 'package:flutter/material.dart';
import 'package:you_matter/features/articles/presentation/ui/article_screen.dart';
import 'package:you_matter/features/chat/presentation/ui/chat_screen.dart';
import 'package:you_matter/features/home/presentation/ui/home_screen.dart';
import 'package:you_matter/features/profile/presentation/ui/profile_screen.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class DashboardController {
  List<Widget> screens(bool isTherapist) => [
        if (!isTherapist) ...{const HomeScreen()},
        const ArticleScreen(),
        ChatScreen(
          chatId: '',
          isTherapist: isTherapist,
        ),
        const ProfileScreen(),
      ];
  StateHandlerBloc baseBloc = StateHandlerBloc();
}

DashboardController dashboardController = DashboardController();
