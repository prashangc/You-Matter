import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc_event.dart';
import 'package:you_matter/services/global_bloc/post_bloc/main_bloc_state.dart';

class MainPostBloc extends Bloc<MainPostEvent, MainPostState> {
  MainPostBloc() : super(LoadingState()) {
    on<LoadingEvent>(loadingEvent);
    on<SuccessEvent>(successEvent);
    on<ErrorEvent>(errorEvent);
    on<ConfirmationEvent>(confirmationEvent);
  }
  loadingEvent(LoadingEvent event, Emitter<MainPostState> emit) {
    emit(LoadingState(context: event.context, msg: event.msg));
  }

  successEvent(SuccessEvent event, Emitter<MainPostState> emit) {
    emit(SuccessState(context: event.context, msg: event.msg));
  }

  errorEvent(ErrorEvent event, Emitter<MainPostState> emit) {
    emit(ErrorState(
        context: event.context,
        msg: event.msg,
        listOfErrors: event.listOfErrors));
  }

  confirmationEvent(ConfirmationEvent event, Emitter<MainPostState> emit) {
    emit(ConfirmationState(
        context: event.context, msg: event.msg, func: event.func));
  }
}
