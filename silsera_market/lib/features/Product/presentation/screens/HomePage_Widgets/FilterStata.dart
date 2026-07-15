class FilterState {
  final String selectedCategory;
  final String? selectedSaleRent;
  final String? selectedHouseType;
  final String? selectedCarType;
  final String? selectedCondition;
  final String? selectedGender;
  final String? selectedSize;
  final String? selectedAccessoryType;
  final String? selectedJobType;
  final double minPrice;
  final double maxPrice;
  final String searchQuery;

  // New fields added
  final String? selectedTransmissionType;
  final String? fuelType;
  final String? electronicsType;
  final String? electronicsConditionType;
  final String? selectedFashionType;
  final String? selectedMaterialType;
  final String? selectedConsultancyServiceType;
  final String? selectedConsultancyBusinessLocation;

  final String? selectedjobexperiancelevel;


  const FilterState({
    required this.selectedCategory,
    this.selectedSaleRent,
    this.selectedHouseType,
    this.selectedCarType,
    this.selectedCondition,
    this.selectedGender,
    this.selectedSize,
    this.selectedAccessoryType,
    this.selectedJobType,
    this.minPrice = 0,
    this.maxPrice = 1000000,
    this.searchQuery = '',
    this.selectedjobexperiancelevel,
    // New fields initialized
    this.selectedTransmissionType,
    this.fuelType,
    this.electronicsType,
    this.electronicsConditionType,
    this.selectedFashionType,
    this.selectedMaterialType,
    this.selectedConsultancyServiceType,
    this.selectedConsultancyBusinessLocation,
  });

  FilterState copyWith({
    String? selectedCategory,
    String? selectedSaleRent,
    String? selectedHouseType,
    String? selectedCarType,
    String? selectedCondition,
    String? selectedGender,
    String? selectedSize,
    String? selectedAccessoryType,
    String? selectedJobType,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
    String? selectedjobexperiancelevel,
    // New fields added to copyWith method
    String? selectedTransmissionType,
    String? fuelType,
    String? electronicsType,
    String? electronicsConditionType,
    String? selectedFashionType,
    String? selectedMaterialType,
    String? selectedConsultancyServiceType,
    String? selectedConsultancyBusinessLocation,
  }) {
    return FilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSaleRent: selectedSaleRent ?? this.selectedSaleRent,
      selectedHouseType: selectedHouseType ?? this.selectedHouseType,
      selectedCarType: selectedCarType ?? this.selectedCarType,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedAccessoryType:
          selectedAccessoryType ?? this.selectedAccessoryType,
      selectedJobType: selectedJobType ?? this.selectedJobType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchQuery: searchQuery ?? this.searchQuery,
      // Copy new fields
      selectedTransmissionType:
          selectedTransmissionType ?? this.selectedTransmissionType,
      fuelType: fuelType ?? this.fuelType,
      electronicsType: electronicsType ?? this.electronicsType,
      electronicsConditionType:
          electronicsConditionType ?? this.electronicsConditionType,
      selectedFashionType: selectedFashionType ?? this.selectedFashionType,
      selectedMaterialType: selectedMaterialType ?? this.selectedMaterialType,
      selectedConsultancyServiceType:
          selectedConsultancyServiceType ?? this.selectedConsultancyServiceType,
      selectedConsultancyBusinessLocation:
          selectedConsultancyBusinessLocation ??
              this.selectedConsultancyBusinessLocation,
              selectedjobexperiancelevel: selectedjobexperiancelevel ??this.selectedjobexperiancelevel,
    );
  }
}
