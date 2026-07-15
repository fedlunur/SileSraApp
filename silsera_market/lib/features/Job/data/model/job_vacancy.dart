import 'dart:convert';

import 'package:silesra/features/Product/data/models/product_model.dart';

class JobVacancyModel extends BaseListing {
  final String? positionType;
  final String? companyName;
  final String? positionTitle;
  final String? worklocation;
  final String? experianceLevel;
  final double? salary;
  final DateTime applicationDeadline;
  final String? JobDescription;
  final String? JobRequirment;

  JobVacancyModel(
      {required this.positionType,
      required this.companyName,
      required this.positionTitle,
      required this.worklocation,
      required this.experianceLevel,
      required this.salary,
      required this.applicationDeadline,
      required this.JobDescription,
      required this.JobRequirment,
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

  factory JobVacancyModel.fromJson(Map<String, dynamic> json) {
    final baseListing = BaseListing.from_dict(json);

    return JobVacancyModel(
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
      positionType: json['positionType'] ?? 'Unknown',
      companyName: json['companyName'] ?? 'Unknown',
      positionTitle: json['positionTitle'] ?? 'Unknown',
      worklocation: json['worklocation'] ?? 'Not specified',
      experianceLevel: json['experianceLevel'] ?? 'Not specified',
      salary: json['salary'] != null ? double.parse(json['salary']) : 0.0,
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.tryParse(json['applicationDeadline']) ?? DateTime.now()
          : DateTime.now(),
      JobDescription: json['JobDescription'] ?? 'No description provided',
      JobRequirment: json['JobRequirment'] ?? 'No requirements specified',
    );
  }

  @override
  String toJson() {
    final jsonMap = {
      ...super.to_dict(),
      'positionType': positionType,
      'companyName': companyName,
      'positionTitle': positionTitle,
      'worklocation': worklocation,
      'experianceLevel': experianceLevel,
      'salary': salary,
      'applicationDeadline': applicationDeadline.toIso8601String(),
      'JobDescription': JobDescription,
      'JobRequirment': JobRequirment,
    };

    return jsonEncode(jsonMap);
  }
}
