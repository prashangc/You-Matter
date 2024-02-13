import 'package:flutter/material.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class RegisterController {
  StateHandlerBloc buttonBloc = StateHandlerBloc();
  StateHandlerBloc pwVisibilityBloc = StateHandlerBloc();
  StateHandlerBloc confirmPwVisibilityBloc = StateHandlerBloc();
  StateHandlerBloc confirmPwValidationBloc = StateHandlerBloc();
  TextEditingController mapController = TextEditingController();
}

RegisterController registerController = RegisterController();
