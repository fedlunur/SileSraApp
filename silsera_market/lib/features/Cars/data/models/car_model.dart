import 'package:silesra/features/Product/data/models/product_model.dart';

class CarModel extends BaseListing {
  String? sellOrRent;
  Map<String, dynamic>? carsubType;
  Map<String, dynamic>? carType;

  String? transmission;

  String? fuelType;
  String? license;
  String? yearofMake; // Make it nullable if JSON can have null
  String? model;
  String? mileage;
  @override
  String? description;

  CarModel(
      {this.sellOrRent,
      this.carsubType,
      this.carType,
      this.transmission,
      this.fuelType,
      this.license,
      this.yearofMake, // Update here
      this.model,
      this.mileage,
      this.description,
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
      required super.isFavourite,
      
      
      });

  @override
  Map<String, dynamic> to_dict() {
    return {
      ...super.to_dict(),
      'sellOrRent': sellOrRent,
      'carsubType': carsubType,
      'name': name,
      'carType': carType,
      'transmission': transmission,
      'fuelType': fuelType,
      'license': license,

      'yearofMake': yearofMake, // Update here
      'model': model,
      'mileage': mileage,
      'description': description,
    };
  }

  factory CarModel.from_dict(Map<String, dynamic> map) {
    final baseListing = BaseListing.from_dict(map);
    return CarModel(
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
      sellOrRent: map['sell_or_rent'], // Match JSON key
      carsubType: map['carsubType'],
      carType: map['carType'],
      
      transmission: map['transmission'],
      fuelType: map['fuelType'],
      license: map['license'],
      yearofMake: map['yearofMake'], // Parse as int
      model: map['model'],
      
      mileage: map['mileage'],

      description: map['description'],
    );
  }
}
