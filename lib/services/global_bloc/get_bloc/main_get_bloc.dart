import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_event.dart';
import 'package:you_matter/services/global_bloc/get_bloc/main_get_state.dart';

class MainGetBloc extends Bloc<MainGetEvent, MainGetState> {
  MainGetBloc() : super(MainGetLoadingState()) {
    on<MainGetLoadingEvent>(onLoading);
    on<MainGetRefreshEvent>(refresh);
  }
  refresh(MainGetRefreshEvent event, Emitter<MainGetState> emit) {
    emit(MainRefreshState());
  }

  onLoading(dynamic event, Emitter<MainGetState> emit) async {
    // http.Response resp =
    //     await api.getData(endpoint: event.endpoint, context: event.context);
    if (200 == 200) {
      var finalResp;
      //  = json.decode(resp.body.toString());
      if (finalResp.isEmpty) {
        emit(MainGetEmptyState());
      } else {
        emit(MainGetSuccessState(resp: finalResp));
      }
    } else {
      emit(MainGetErrorState(statusCode: '400'));
    }
  }
}
