class Car {
  String? id;
  String? sellOrRent;
  String? carMake;
  String? carType;
  String? transmission;
  String? fuelType;
  double price;
  String? license;
  int yearofMake;
  String? model;
  int? mileage;
  String? description;
  String? carimage;

  Car({
    this.id,
    this.sellOrRent,
    this.carMake,
    this.carType,
    this.transmission,
    this.fuelType,
    required this.price,
    this.license,
    required this.yearofMake,
    this.model,
    this.mileage,
    this.description,
    this.carimage,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      sellOrRent: json['sellOrRent'],
      carMake: json['carMake'],
      carType: json['carType'],
      transmission: json['transmission'],
      fuelType: json['fuelType'],
      price: json['price'],
      license: json['license'],
      yearofMake: json['yearofMake'],
      model: json['model'],
      mileage: json['mileage'],
      description: json['description'],
      carimage: json['carimage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellOrRent': sellOrRent,
      'carMake': carMake,
      'carType': carType,
      'transmission': transmission,
      'fuelType': fuelType,
      'price': price,
      'license': license,
      'yearofMake': yearofMake,
      'model': model,
      'mileage': mileage,
      'description': description,
      'carimage': carimage,
    };
  }
}
