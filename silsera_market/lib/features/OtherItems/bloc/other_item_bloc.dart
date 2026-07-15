import 'package:bloc/bloc.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';
import 'package:silesra/features/OtherItems/data/usecase/usecase.dart';

part 'other_item_event.dart';
part 'other_item_state.dart';

class OtherItemBloc extends Bloc<OtherItemEvent, OtherItemState> {
  final GetOtherItems getOtherItems;
  final AddOtherItem addOtherItem;
  final UpdateOtherItem updateOtherItem;
  final DeleteOtherItem deleteOtherItem;

  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _isFetching = false;

  OtherItemBloc({
    required this.getOtherItems,
    required this.addOtherItem,
    required this.updateOtherItem,
    required this.deleteOtherItem,
  }) : super(OtherItemInitial()) {
    on<FetchOtherItem>(_onFetchOtherItem);
    on<FetchMoreOtherItems>(_onFetchMoreOtherItems);
    on<AddOtherItemEvent>(_onAddOtherItem);
    on<UpdateOtherItemEvent>(_onUpdateOtherItem);
    on<DeleteOtherItemEvent>(_onDeleteOtherItem);
  }

  Future<void> _onFetchOtherItem(
      FetchOtherItem event, Emitter<OtherItemState> emit) async {
    emit(OtherItemLoading());
    _currentPage = 1;

    try {
      final items =
          await getOtherItems(page: _currentPage, pageSize: _pageSize);
      emit(OtherItemLoaded(items, hasReachedMax: items.length < _pageSize));
      _currentPage++;
    } catch (e) {
      emit(OtherItemError(e.toString()));
    }
  }

  Future<void> _onFetchMoreOtherItems(
      FetchMoreOtherItems event, Emitter<OtherItemState> emit) async {
    if (_isFetching || state is! OtherItemLoaded) return;
    _isFetching = true;

    final currentState = state as OtherItemLoaded;
    if (currentState.hasReachedMax) return;

    try {
      final moreItems =
          await getOtherItems(page: _currentPage, pageSize: _pageSize);
      if (moreItems.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        emit(currentState.copyWith(
          items: currentState.items + moreItems,
          hasReachedMax: moreItems.length < _pageSize,
        ));
        _currentPage++;
      }
    } catch (e) {
      emit(OtherItemPaginationError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onAddOtherItem(
      AddOtherItemEvent event, Emitter<OtherItemState> emit) async {
    emit(OtherItemLoading());
    try {
      await addOtherItem(event.otherItem);
      add(FetchOtherItem());
    } catch (e) {
      emit(OtherItemError(e.toString()));
    }
  }

  Future<void> _onUpdateOtherItem(
      UpdateOtherItemEvent event, Emitter<OtherItemState> emit) async {
    emit(OtherItemLoading());
    try {
      await updateOtherItem(event.otherItem);
      add(FetchOtherItem());
    } catch (e) {
      emit(OtherItemError(e.toString()));
    }
  }

  Future<void> _onDeleteOtherItem(
      DeleteOtherItemEvent event, Emitter<OtherItemState> emit) async {
    emit(OtherItemLoading());
    try {
      await deleteOtherItem(event.id as String);
      add(FetchOtherItem());
    } catch (e) {
      emit(OtherItemError(e.toString()));
    }
  }
}
