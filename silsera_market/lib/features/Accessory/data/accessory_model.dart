// ignore_for_file: public_member_api_docs, sort_constructors_first
// Model
import 'dart:convert';

import 'package:silesra/features/Product/data/models/product_model.dart';

class AccessoryModel extends BaseListing {
  final String? accessoryType;
  final String? condition;
  final String? brand;
  final String? sellOrRent;
  @override
  final String? description;
  AccessoryModel({
    this.accessoryType,
    this.condition,
    this.brand,
    this.sellOrRent,
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
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    final baseListing = BaseListing.from_dict(json);
    return AccessoryModel(
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
      description: json['description'],
      sellOrRent: json['sell_or_rent'],
      accessoryType: json['accessoryType'],
      condition: json['condition'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessoryType': accessoryType,
      'condition': condition,
      'brand': brand,
      'sellOrRent': sellOrRent
    };
  }
}
