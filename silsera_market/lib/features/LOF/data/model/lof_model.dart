import 'package:silesra/features/Product/data/models/product_model.dart';

class LostOrFound extends BaseListing {
  String typeofadd;
  String? title;
  @override
  String? description;
  String? sellOrRent;

  LostOrFound(
      {required this.typeofadd,
      this.title,
      this.description,
      this.sellOrRent,
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
      'typeofadd': typeofadd,
      'title': title,
      'description': description,
    };
  }

  factory LostOrFound.from_dict(Map<String, dynamic> map) {
    var baseListing = BaseListing.from_dict(map);
    return LostOrFound(
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
      isFavourite: baseListing.isFavourite,
      typeofadd: map['typeofadd'],
      title: map['title'],
      description: map['description'],
      sellOrRent: map['SellOrRent'] ?? 'None',
    );
  }
}
