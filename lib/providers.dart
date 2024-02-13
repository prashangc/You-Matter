import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc.dart';

class AllProviders {
  static get providers => [
        BlocProvider(
          create: (context) => MainPostBloc(),
        ),
        BlocProvider(
          create: (context) => MainGetBloc(),
        ),
      ];
}
