import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/utils/my_check_internet_connection.dart';
import 'package:you_matter/core/utils/my_pop_up.dart';
import 'package:you_matter/features/dashboard/presentation/ui/base.dart';
import 'package:you_matter/features/login/model/login_model.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc_event.dart';

class LoginController {
  onBtnCick(context, LoginModel model) async {
    bool internetStatus = await checkInternetConnection(context);
    MainPostBloc bloc = BlocProvider.of<MainPostBloc>(context);
    if (internetStatus == true) {
      popUpHelper.loadingAlert(context: context, myTap: () {});
      bloc.add(LoadingEvent(context: context, msg: 'Logging in ...'));
      try {
        final firebaseAuth = FirebaseAuth.instance;
        UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: model.email!, password: model.password!);
        final preference = await SharedPreferences.getInstance();
        if (userCredential.user?.uid != null) {
          await preference.setString("uid", userCredential.user!.uid);
        }
        pushTo(
            context: context,
            screen: const BasePage(
              currentIndex: 0,
            ));
        bloc.add(SuccessEvent(context: context, msg: 'Login successfully !!!'));
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
}

LoginController loginController = LoginController();
