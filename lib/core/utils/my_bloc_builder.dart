import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/my_empty_card.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_bloc.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_event.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_state.dart';

Widget myBlocBuilder({
  required String endpoint,
  required MainGetBloc mainGetBloc,
  required String emptyMsg,
  required String subtitle,
  required Widget Function(dynamic resp) card,
  required BuildContext context,
}) {
  return BlocProvider(
    create: (context) => mainGetBloc,
    child: BlocBuilder<MainGetBloc, MainGetState>(
      builder: (blocContext, state) {
        if (state is MainGetLoadingState || state is MainRefreshState) {
          BlocProvider.of<MainGetBloc>(blocContext).add(
            MainGetLoadingEvent(
              endpoint: endpoint,
              context: context,
              emptyMsg: emptyMsg,
            ),
          );
          return Center(
            child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: ColorConstant.kWhite,
                  backgroundColor: ColorConstant.kPrimary,
                )),
          );
        } else if (state is MainGetSuccessState) {
          return card(state.resp);
        } else if (state is MainGetEmptyState) {
          return myEmptyCard(
              context: context, emptyMsg: emptyMsg, subTitle: subtitle);
        } else if (state is MainGetRequestTimeoutState) {
          return const Text('timeout');
        } else if (state is MainGetNoInternetState) {
          return const Text('no internet');
        } else if (state is MainGetErrorState) {
          return Text('server error ${state.statusCode}');
        } else {
          return const Text('something went wrong');
        }
      },
    ),
  );
}
