import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';
import 'package:silesra/features/OtherItems/data/model/repo/repo.dart';

class GetOtherItems {
  final OtherItemRepository repository;

  GetOtherItems(this.repository);
  Future<List<OtherItem>> call({required int page, required int pageSize}) async {
  
    return await repository.getOtherItems(page: page, pageSize: pageSize);
  }
}

class GetOtherItemById {
  final OtherItemRepository repository;

  GetOtherItemById(this.repository);

  Future<OtherItem> call(String id) async {
    return await repository.getOtherItemById(id);
  }
}

class AddOtherItem {
  final OtherItemRepository repository;

  AddOtherItem(this.repository);

  Future<void> call(OtherItem otherItem) async {
    return await repository.addOtherItem(otherItem);
  }
}

class UpdateOtherItem {
  final OtherItemRepository repository;

  UpdateOtherItem(this.repository);

  Future<void> call(OtherItem otherItem) async {
    return await repository.updateOtherItem(otherItem);
  }
}

class DeleteOtherItem {
  final OtherItemRepository repository;

  DeleteOtherItem(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteOtherItem(id);
  }
}
