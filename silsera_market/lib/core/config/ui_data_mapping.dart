Map<String, String> categoryTitleMapping = {
  "Car": "name",
  "House": "name",
  "OtherItems": "title",
  "Accessories": "name",
  "Fashion": "name",
  "Electronics": "name",
  "Job": "positionTitle",
  "ServiceOrBusinessType": "busienssOrServiceType",
  "Lost or Found": "title",
  'Services': "title",
  
  "FreeStaffOrItem": "title",
  "Others": "name",
};
//       final String? positionType;
// final String? companyName;
// final String? positionTitle;
// final String? workLocation;
// final String? experienceLevel;
Map<String, String> categoryPriceMapping = {
  "Car": "price",
  "House": "price",
  "OtherItems": "price",
  "Accessories": "price",
  "Fashion": "price",
  "Electronics": "price",
  "ServiceOrBusinessType": "price",
  'Services': 'price',
  "Job": "salary",
  "Lost or Found": "none",
  "FreeStaffOrItem": "none",
  "Others": "price",
};
Map<String, String> categorySaleRentMapping = {
  "Car": "sell_or_rent",
  "House": "sell_or_rent",
  "OtherItems": "sell_or_rent",
  "Accessories": "sell_or_rent",
  "Fashion": "sell_or_rent",
  "Electronics": "sell_or_rent",
  "ServiceOrBusinessType": "none",
  'Services': 'none',
  "Job": "positionType",
  "Lost or Found": "none",
  "FreeStaffOrItem": "none",
  "Others": "sell_or_rent",
};
Map<String, dynamic> categoryMappings = {
  "Car": {
    "name": "name",
    "sellOrRent": "sellOrRent",
    "details": {
      "carsubType": "carsubType",
      "carType": "carType",
      "transmission": "transmission",
      "fuelType": "fuelType",
      "license": "license",
      "yearofMake": "yearofMake",
      "model": "model",
      "mileage": "mileage"
    }
  },
  "House": {
    "name": "name",
    "sellOrRent": "sellOrRent",
    "details": {
      "houseType": "houseType",
      "numberofBedrooms": "numberofBedrooms",
      "numberofBathrooms": "numberofBathrooms",
      "area": "area",
      "license": "license",
      "description": "description"
    }
  },
  "Accessory": {
    "name": "name",
    "sellOrRent": "sellOrRent",
    "details": {
      "accessoryType": "accessoryType",
      "condition": "condition",
      "manufacturer": "manufacturer"
    }
  },
  "Fashion": {
    "name": "name",
    "sellOrRent": "sellOrRent",
    "details": {
      "fashionType": "fashionType",
      "gender": "gender",
      "size": "size",
      "material": "material",
      "condition": "condition",
      "brand": "brand"
    }
  },
  "Electronics": {
    "name": "name",
    "sellOrRent": "sellOrRent",
    "details": {
      "electronicsType": "electronicsType",
      "brand": "brand",
      "model": "model",
      "condition": "condition",
      "warranty": "warranty"
    }
  }
};
