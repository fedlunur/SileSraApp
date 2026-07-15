import 'package:bloc/bloc.dart';
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';
import 'package:silesra/features/FreeStuff/domain/free_stuff_domain.dart';

part 'freestaff_event.dart';
part 'freestaff_state.dart';

class FreestaffBloc extends Bloc<FreestaffEvent, FreestaffState> {
  final GetFreeStaffOrItems getFreeStaffOrItems;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false;

  FreestaffBloc({
    required this.getFreeStaffOrItems,
  }) : super(FreestaffInitial()) {
    on<FetchFreestaff>(_onFetchFreestaff);
    on<FetchMoreFreestaff>(_onFetchMoreFreestaff);
  }

  Future<void> _onFetchFreestaff(
      FetchFreestaff event, Emitter<FreestaffState> emit) async {
    emit(FreestaffLoading());
    _currentPage = 1;

    try {
      final items = await getFreeStaffOrItems(page: _currentPage, pageSize: _pageSize);
      emit(FreestaffLoaded(
        freestaff: items,
        hasReachedMax: items.length < _pageSize,
      ));
      _currentPage++;
    } catch (e) {
      emit(FreestaffError(e.toString()));
    }
  }

  Future<void> _onFetchMoreFreestaff(
      FetchMoreFreestaff event, Emitter<FreestaffState> emit) async {
    if (state is FreestaffLoaded) {
      final currentState = state as FreestaffLoaded;

      if (currentState.hasReachedMax || _isFetching) return;
      _isFetching = true;

      try {
        final moreItems = await getFreeStaffOrItems(page: _currentPage, pageSize: _pageSize);
        if (moreItems.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            freestaff: currentState.freestaff + moreItems,
            hasReachedMax: moreItems.length < _pageSize,
          ));
          _currentPage++;
        }
      } catch (e) {
        emit(FreestaffPaginationError(e.toString()));
      } finally {
        _isFetching = false;
      }
    }
  }
}

