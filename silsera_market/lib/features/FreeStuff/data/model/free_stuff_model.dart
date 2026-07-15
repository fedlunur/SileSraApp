import 'package:silesra/features/Product/data/models/product_model.dart';

class FreeStaffOrItem extends BaseListing {
  String? title;
  @override
  String? description;

  FreeStaffOrItem({
    this.title,
    this.description,
    required super.id,
    required super.name,
    required super.created,
    required super.updated,
    required super.approvalStatus,
    required super.paymentStatus,
    required super.removed,
    required super.city,
    required super.phonenumber,
    required super.latitude,
    required super.longitude,
    required super.price,
    required super.contentType,
    required super.seen,
    required super.postedby,
    required super.feeReciptImage,
    required super.feeReciptRefnumber,
    required super.servicefeeBank,
    required super.category,
    required super.images,
    required super.reciptimages,
    required super.isFavourite,
  });

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'title': title,
      'description': description,
    };
  }

  factory FreeStaffOrItem.from_dict(Map<String, dynamic> map) {
    try {
      // Debugging the base listing
      var baseListing = BaseListing.from_dict(map);
      print('BaseListing parsed successfully');

      // Debugging category field

      return FreeStaffOrItem(
        
	  id: baseListing.id,
      name: baseListing.name,
      city: baseListing.city,
      approvalStatus: baseListing.approvalStatus,
      paymentStatus: baseListing.paymentStatus,
      feeReciptImage: baseListing.feeReciptImage,
      feeReciptRefnumber: baseListing.feeReciptRefnumber,
      latitude: baseListing.latitude,
      longitude: baseListing.longitude,
      phonenumber: baseListing.phonenumber,
      removed: baseListing.removed,
      created: baseListing.created,
      updated: baseListing.updated,
      price: baseListing.price,
      servicefeeBank: baseListing.servicefeeBank,
      category: baseListing.category,
      images: baseListing.images,
      reciptimages: baseListing.reciptimages,
      postedby: baseListing.postedby,
      contentType: baseListing.contentType,
     isFavourite:baseListing.isFavourite,
      seen: baseListing.seen,
        title: map['title'] ?? 'title',
        description: map['description'] ?? 'disc',
      );
    } catch (e) {
      print('%%%%%%%%%%%%%%%%5 Error parsing FreeStaffOrItem: $e');
      rethrow;
    }
  }
}
