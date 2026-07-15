import 'package:silesra/features/Product/data/models/product_model.dart';

class FashionModel extends BaseListing {
  final String? fashionType;
  final String? gender;
  final String? size;
  final String? material;
  final String? condition;
  final String? brand;
  @override
  final String? description;
  final String? sellOrRent;

  FashionModel(
      {this.brand,
      this.fashionType,
      this.gender,
      this.size,
      this.material,
      this.condition,
      this.description,
      this.sellOrRent,
         required super.id,
      required super.contentType,
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
      required super.images,
      required super.reciptimages,
      required super.seen,
      required super.postedby,
      required super.isFavourite
      });

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'fashionType': fashionType,
      'gender': gender,
      'size': size,
      'material': material,
      'condition': condition,
      'description': description,
    };
  }

  factory FashionModel.from_dict(Map<String, dynamic> map) {
    var baseListing = BaseListing.from_dict(map);
    return FashionModel(
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
      isFavourite:baseListing.isFavourite,
      sellOrRent: map['sell_or_rent'],
      fashionType: map['fashionType'],
      gender: map['gender'],
      size: map['size'],
      description: map['description'],
      condition: map['condition'],
      material: map['material'],
      brand: map['brand'],
    );
  }
}
