import 'package:silesra/features/Product/data/models/product_model.dart';

class OtherItem extends BaseListing {
  String? sellOrRent;
  Map<String, dynamic>? otherItemcategory;
  String? title;
  @override
  String? description;

  OtherItem(
      {this.sellOrRent,
      this.otherItemcategory,
      this.title,
      this.description,
      required super.images,
      required super.reciptimages,
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
      required super.feeReciptImage,
      required super.feeReciptRefnumber,
      required super.servicefeeBank,
      required super.category,
      required super.price,
      required super.contentType,
      required super.seen,
      required super.postedby,
      required super.isFavourite});

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'sellOrRent': sellOrRent,
      'otherItemcategory': otherItemcategory,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory OtherItem.from_dict(Map<String, dynamic> map) {
    final baseListing = BaseListing.from_dict(map);
    return OtherItem(
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
      seen: baseListing.seen,
      sellOrRent: map["sell_or_rent"],
      isFavourite: baseListing.isFavourite,
      otherItemcategory: map['otherItemcategory'] != null
          ? Map<String, dynamic>.from(map['otherItemcategory'])
          : null,
      title: map['title'],
      description: map['description'],
    );
  }
}
