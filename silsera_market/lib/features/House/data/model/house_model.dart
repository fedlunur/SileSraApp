import 'package:silesra/features/Product/data/models/product_model.dart';

class HouseModel extends BaseListing {
  String? sellOrRent;
  String? houseType;
  int numberofBedrooms;
  int numberofBathrooms;
  String? area;
  String? license;
  @override
  String? description;
// ✅ Add postedby field

  HouseModel({
    this.area,
    this.sellOrRent,
    this.houseType,
    this.license,
    this.description,
  
    required this.numberofBedrooms,
    required this.numberofBathrooms,
   
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
    required super.isFavourite
  });

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'sellOrRent': sellOrRent,
      'houseType': houseType,
      'numberofBedrooms': numberofBedrooms,
      'numberofBathrooms': numberofBathrooms,
      'area': area,
      'license': license,
      'description': description,
      'postedby': postedby, // ✅ Include postedby in serialization
    };
  }

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    final baseListing = BaseListing.from_dict(json);
    print("📌 HouseModel received postedby:===>  ${baseListing.postedby}");
    return HouseModel(
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
      contentType: baseListing.contentType,
      seen: baseListing.seen,
       postedby: baseListing.postedby,
      category: baseListing.category,
      servicefeeBank: baseListing.servicefeeBank,
      images: baseListing.images,
      reciptimages: baseListing.reciptimages,
      isFavourite:baseListing.isFavourite,

      
      sellOrRent: json['sell_or_rent'],
      houseType: json['houseType'],
      numberofBedrooms: json['numberofBedrooms'],
      numberofBathrooms: json['numberofBathrooms'],
      area: json['area'],
      license: json['license'],
      description: json['description'],
     
    );
  }
}
