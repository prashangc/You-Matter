abstract class MainGetState {}

class MainGetLoadingState extends MainGetState {}

class MainGetSuccessState extends MainGetState {
  dynamic resp;
  MainGetSuccessState({required this.resp});
}

class MainGetErrorState extends MainGetState {
  String statusCode;
  MainGetErrorState({required this.statusCode});
}

class MainGetRequestTimeoutState extends MainGetState {}

class MainGetNoInternetState extends MainGetState {}

class MainGetEmptyState extends MainGetState {}

class MainRefreshState extends MainGetState {}
