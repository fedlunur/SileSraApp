// FreeStaffOrItem Entity
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';

class FreeStaffOrItemEntity {
  final String? id;
  final String? title;
  final String? description;
 

  FreeStaffOrItemEntity({
    this.id,
    this.title,
    this.description,

  });
}

// FreeStaffOrItem Repository Interface
abstract class FreeStaffOrItemRepository {
  Future<List<FreeStaffOrItem>> getFreeStaffOrItems({required int page, required int pageSize});
  Future<FreeStaffOrItem> getFreeStaffOrItemById(String id);
  Future<void> addFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
  Future<void> updateFreeStaffOrItem(FreeStaffOrItem freeStaffOrItem);
  Future<void> deleteFreeStaffOrItem(String id);
}

// Use Cases
class GetFreeStaffOrItems {
  final FreeStaffOrItemRepository repository;

  GetFreeStaffOrItems(this.repository);

  Future<List<FreeStaffOrItem>> call({required int page, required int pageSize}) async {
    return await repository.getFreeStaffOrItems(page: page, pageSize: pageSize);
  }
}

class GetFreeStaffOrItemById {
  final FreeStaffOrItemRepository repository;

  GetFreeStaffOrItemById(this.repository);

  Future<FreeStaffOrItem> call(String id) async {
    return await repository.getFreeStaffOrItemById(id);
  }
}

class AddFreeStaffOrItem {
  final FreeStaffOrItemRepository repository;

  AddFreeStaffOrItem(this.repository);

  Future<void> call(FreeStaffOrItem freeStaffOrItem) async {
    return await repository.addFreeStaffOrItem(freeStaffOrItem);
  }
}

class UpdateFreeStaffOrItem {
  final FreeStaffOrItemRepository repository;

  UpdateFreeStaffOrItem(this.repository);

  Future<void> call(FreeStaffOrItem freeStaffOrItem) async {
    return await repository.updateFreeStaffOrItem(freeStaffOrItem);
  }
}

class DeleteFreeStaffOrItem {
  final FreeStaffOrItemRepository repository;

  DeleteFreeStaffOrItem(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFreeStaffOrItem(id);
  }
}
