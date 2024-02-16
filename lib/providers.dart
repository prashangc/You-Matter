import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc.dart';

class AllProviders {
  static get providers => [
        BlocProvider(
          create: (context) => MainPostBloc(),
        ),
      ];
}
