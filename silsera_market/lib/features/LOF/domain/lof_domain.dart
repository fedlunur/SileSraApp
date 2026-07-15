// LostOrFound Entity
import 'package:silesra/features/LOF/data/model/lof_model.dart';

class LostOrFoundEntity {
  final String? id;
  final String typeofadd;
  final String? title;
  final String? description;
  final List<String>? serviceImage;

  LostOrFoundEntity({
    this.id,
    required this.typeofadd,
    this.title,
    this.description,
    this.serviceImage,
  });
}

// LostOrFound Repository Interface
abstract class LostOrFoundRepository {
  Future<List<LostOrFound>> getLostOrFounds({required int page, required int pageSize});
  Future<LostOrFound> getLostOrFoundById(String id);
  Future<void> addLostOrFound(LostOrFound lostOrFound);
  Future<void> updateLostOrFound(LostOrFound lostOrFound);
  Future<void> deleteLostOrFound(String id);
}

// Use Cases
class GetLostOrFounds {
  final LostOrFoundRepository repository;

  GetLostOrFounds(this.repository);

  Future<List<LostOrFound>> call( {required int page, required int pageSize}) async {
    return await repository.getLostOrFounds(page: page, pageSize: pageSize);
  }
}

class GetLostOrFoundById {
  final LostOrFoundRepository repository;

  GetLostOrFoundById(this.repository);

  Future<LostOrFound> call(String id) async {
    return await repository.getLostOrFoundById(id);
  }
}

class AddLostOrFound {
  final LostOrFoundRepository repository;

  AddLostOrFound(this.repository);

  Future<void> call(LostOrFound lostOrFound) async {
    return await repository.addLostOrFound(lostOrFound);
  }
}

class UpdateLostOrFound {
  final LostOrFoundRepository repository;

  UpdateLostOrFound(this.repository);

  Future<void> call(LostOrFound lostOrFound) async {
    return await repository.updateLostOrFound(lostOrFound);
  }
}

class DeleteLostOrFound {
  final LostOrFoundRepository repository;

  DeleteLostOrFound(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteLostOrFound(id);
  }
}
