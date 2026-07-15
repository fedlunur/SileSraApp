import 'package:dio/dio.dart';
import 'package:silesra/features/POST/BaseService.dart';

import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';
import 'package:silesra/core/config/settings.dart';

abstract class WatchlistRemoteDataSource {
  Future<List<Watchlist>> getWatchlists();
  Future<Watchlist> getWatchlistById(String id);
  Future<void> addWatchlist(Watchlist watchlist);
  Future<void> updateWatchlist(Watchlist watchlist);
  Future<void> deleteWatchlist(String id);
}

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final Dio dio;
  BaseService<Watchlist> baseService;
  WatchlistRemoteDataSourceImpl({required this.dio, required this.baseService});

  @override
  Future<List<Watchlist>> getWatchlists() async {
    final response = await baseService.getRequestModelData('watchlist');

    return (response.data['result'] as List)
        .map((e) => Watchlist.from_dict(e))
        .toList();
  }

  @override
  Future<Watchlist> getWatchlistById(String id) async {
    final response = await dio.get(baseUrl + 'watchlists/$id');
    return Watchlist.from_dict(response.data);
  }

  @override
  Future<void> addWatchlist(Watchlist watchlist) async {
    await dio.post(baseUrl + 'watchlist', data: watchlist.to_dict());
  }

  @override
  Future<void> updateWatchlist(Watchlist watchlist) async {
    await dio.put('/watchlists/$watchlist', data: watchlist.to_dict());
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    await dio.delete('/watchlists/$id');
  }
}
