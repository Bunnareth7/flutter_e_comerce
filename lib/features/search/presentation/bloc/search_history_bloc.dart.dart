import 'package:e_com_app/features/search/presentation/bloc/search_history_event.dart.dart';
import 'package:e_com_app/features/search/presentation/bloc/search_history_state.dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_search_history.dart';
import '../../domain/usecases/add_search_history.dart';
import '../../domain/usecases/clear_search_history.dart' as clear_uc;


class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final GetSearchHistory getSearchHistory;
  final AddSearchHistory addSearchHistory;
  final clear_uc.ClearSearchHistory clearSearchHistory;

  SearchHistoryBloc({
    required this.getSearchHistory,
    required this.addSearchHistory,
    required this.clearSearchHistory,
  }) : super(SearchHistoryInitial()) {
    on<LoadSearchHistory>(_onLoad);
    on<AddSearchQuery>(_onAdd);
    on<ClearSearchHistory>(_onClear);
  }

  void _onLoad(LoadSearchHistory event, Emitter<SearchHistoryState> emit) async {
    emit(SearchHistoryLoading());
    final result = await getSearchHistory(GetSearchHistoryParams());
    result.fold(
      (failure) => emit(SearchHistoryError(failure.message)),
      (history) => emit(SearchHistoryLoaded(history)),
    );
  }

  void _onAdd(AddSearchQuery event, Emitter<SearchHistoryState> emit) async {
    await addSearchHistory(AddSearchHistoryParams(event.query));
    add(LoadSearchHistory());
  }

  void _onClear(ClearSearchHistory event, Emitter<SearchHistoryState> emit) async {
    await clearSearchHistory(NoParams());
    add(LoadSearchHistory());
  }
}