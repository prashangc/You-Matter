import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/core/utils/my_check_internet_connection.dart';
import 'package:you_matter/core/utils/my_pop_up.dart';
import 'package:you_matter/features/register/model/register_model.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc_event.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class RegisterController {
  StateHandlerBloc buttonBloc = StateHandlerBloc();
  StateHandlerBloc pwVisibilityBloc = StateHandlerBloc();
  StateHandlerBloc confirmPwVisibilityBloc = StateHandlerBloc();
  StateHandlerBloc confirmPwValidationBloc = StateHandlerBloc();
  TextEditingController mapController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  onBtnCick(context, RegisterModel model) async {
    bool internetStatus = await checkInternetConnection(context);
    MainPostBloc bloc = BlocProvider.of<MainPostBloc>(context);
    if (internetStatus == true) {
      popUpHelper.loadingAlert(context: context, myTap: () {});
      bloc.add(LoadingEvent(context: context, msg: 'Creating user account'));
      try {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: model.email!, password: model.password!)
            .then((value) async {
          await createUserInFireStore(value.user, model.name);
        });
        bloc.add(SuccessEvent(
            context: context, msg: 'User account successfully created'));
      } catch (e) {
        bloc.add(
          ErrorEvent(
            context: context,
            msg: e is FirebaseAuthException ? e.message : e.toString(),
            listOfErrors: [],
          ),
        );
      } finally {}
    } else {
      bloc.add(
        ErrorEvent(
          context: context,
          msg: 'No internet',
          listOfErrors: [],
        ),
      );
    }
  }

  Future<void> createUserInFireStore(User? user, String? username) async {
    if (user != null && username != null) {
      final userDoc = await FirebaseQueryHelper.getSingleDocument(
          collectionPath: 'users', docID: user.uid);
      if (userDoc?.exists != true) {
        FirebaseQueryHelper.addDataToDocument(data: {
          'username': username,
          'email': user.email,
          'createdOn': DateTime.now(),
        }, collectionID: 'users', docID: user.uid);
      }
    }
  }
}

RegisterController registerController = RegisterController();
