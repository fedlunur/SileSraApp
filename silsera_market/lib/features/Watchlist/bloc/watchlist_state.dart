import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Watchlist> watchlists;

  WatchlistLoaded(this.watchlists);
}

class WatchlistDetailLoaded extends WatchlistState {
  final Watchlist watchlist;

  WatchlistDetailLoaded(this.watchlist);
}

class WatchlistOperationSuccess extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);
}

class AdditionalDataLoaded extends WatchlistState {
  final Map<String, dynamic> additionalData;

  AdditionalDataLoaded(this.additionalData);
}
