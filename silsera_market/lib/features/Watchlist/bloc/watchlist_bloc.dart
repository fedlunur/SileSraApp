import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_event.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_state.dart';
import 'package:silesra/features/Watchlist/domain/watchList_usecase.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlists getWatchlists;
  final Dio dio; // Add Dio for making HTTP requests

  WatchlistBloc({required this.getWatchlists, required this.dio})
      : super(WatchlistInitial());

  @override
  Stream<WatchlistState> mapEventToState(WatchlistEvent event) async* {
    if (event is FetchWatchlists) {
      yield WatchlistLoading();
      try {
        final watchlists = await getWatchlists();
        yield WatchlistLoaded(watchlists);
      } catch (e) {
        yield WatchlistError(e.toString());
      }
    } else if (event is FetchAdditionalData) {
      yield WatchlistLoading();
      try {
        // Make a GET request to the endpoint
        final response = await dio.get(
          '$baseUrl/${event.contentTypeName}/${event.objectId}', // Adjust the endpoint as needed
        );
        print(response.data);
        yield AdditionalDataLoaded(response.data);
      } catch (e) {
        yield WatchlistError(e.toString());
      }
    }
  }
}
