import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';

abstract class WatchlistEvent {}

class FetchWatchlists extends WatchlistEvent {}

class FetchWatchlistById extends WatchlistEvent {
  final String id;

  FetchWatchlistById(this.id);
}

class AddWatchlistEvent extends WatchlistEvent {
  final Watchlist watchlist;

  AddWatchlistEvent(this.watchlist);
}

class UpdateWatchlistEvent extends WatchlistEvent {
  final Watchlist watchlist;

  UpdateWatchlistEvent(this.watchlist);
}

class DeleteWatchlistEvent extends WatchlistEvent {
  final int id;

  DeleteWatchlistEvent(this.id);
}

class FetchAdditionalData extends WatchlistEvent {
  final String contentTypeName;
  final String objectId;

  FetchAdditionalData({required this.contentTypeName, required this.objectId});
}
