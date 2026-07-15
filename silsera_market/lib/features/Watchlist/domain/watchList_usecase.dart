import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';
import 'package:silesra/features/Watchlist/data/model/watchlist_repo.dart';

class GetWatchlists {
  final WatchlistRepository repository;

  GetWatchlists(this.repository);

  Future<List<Watchlist>> call() async {
    return await repository.getWatchlists();
  }
}
