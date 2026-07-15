import 'package:silesra/features/Product/data/models/product_model.dart';

class ServiceOrBusinessType extends BaseListing {
  String? busienssOrServiceType;
  String? businessLocation;
  String? title;
  @override
  double? price;
  @override
  String? description;

  ServiceOrBusinessType(
      {this.busienssOrServiceType,
      this.businessLocation,
      this.title,
      this.price,
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
      required super.contentType,
      required super.seen,
      required super.postedby});

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'name': name,
      'price': price,
      'busienssOrServiceType': busienssOrServiceType,
      'businessLocation': businessLocation,
      'title': title,
      'description': description,
    };
  }

  factory ServiceOrBusinessType.from_dict(Map<String, dynamic> map) {
    var baseListing = BaseListing.from_dict(map);
    return ServiceOrBusinessType(
       
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
   
      servicefeeBank: baseListing.servicefeeBank,
      category: baseListing.category,
      images: baseListing.images,
      reciptimages: baseListing.reciptimages,
      postedby: baseListing.postedby,
      contentType: baseListing.contentType,
      seen: baseListing.seen,
      busienssOrServiceType: map['busienssOrServiceType'],
      businessLocation: map['businessLocation'] ?? 'Some where',
      title: map['title'],
      price: map['price'] != null ? double.parse(map['price']) : 0.0,
      description: map['description'],
    );
  }
}
