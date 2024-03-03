import 'package:flutter/material.dart';
import 'package:you_matter/services/state/state_bloc.dart';

class SearchController {
  StateHandlerBloc searchBloc = StateHandlerBloc();
  TextEditingController textEditingController = TextEditingController();
}

SearchController searchController = SearchController();
