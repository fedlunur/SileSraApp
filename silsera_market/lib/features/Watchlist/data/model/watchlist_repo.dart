import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';
import 'package:silesra/features/Watchlist/data/watchlist_datasource/watchlist_datasource.dart';

abstract class WatchlistRepository {
  Future<List<Watchlist>> getWatchlists();
  Future<Watchlist> getWatchlistById(String id);
  Future<void> addWatchlist(Watchlist watchlist);
  Future<void> updateWatchlist(Watchlist watchlist);
  Future<void> deleteWatchlist(String id);
}

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistRemoteDataSource remoteDataSource;

  WatchlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Watchlist>> getWatchlists() async {
    return await remoteDataSource.getWatchlists();
  }

  @override
  Future<Watchlist> getWatchlistById(String id) async {
    return await remoteDataSource.getWatchlistById(id);
  }

  @override
  Future<void> addWatchlist(Watchlist watchlist) async {
    return await remoteDataSource.addWatchlist(watchlist);
  }

  @override
  Future<void> updateWatchlist(Watchlist watchlist) async {
    return await remoteDataSource.updateWatchlist(watchlist);
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    return await remoteDataSource.deleteWatchlist(id);
  }
}
