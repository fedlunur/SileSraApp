// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/settings.dart';

import 'package:silesra/features/Accessory/presentation/bloc/accessory_bloc.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

import 'package:silesra/features/Cars/presentation/bloc/car_bloc.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_event.dart';
import 'package:silesra/features/Cars/presentation/bloc/car_state.dart';
import 'package:silesra/features/Electronics/bloc/electronics_bloc.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_bloc.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_event.dart';
import 'package:silesra/features/Fashion/presenation/bloc/fashion_state.dart';
import 'package:silesra/features/FreeStuff/bloc/freestaff_bloc.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_bloc.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_event.dart';
import 'package:silesra/features/House/presentation/bloc/house_bloc_state.dart';
import 'package:silesra/features/Job/presentation/bloc/job_bloc.dart';
import 'package:silesra/features/Job/presentation/bloc/job_event.dart';
import 'package:silesra/features/Job/presentation/bloc/job_state.dart';
import 'package:silesra/features/LOF/presentation/lof_bloc.dart';
import 'package:silesra/features/Notification/bloc/notification_bloc.dart';
import 'package:silesra/features/OtherItems/bloc/other_item_bloc.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Product/presentation/screens/HomePage_Widgets/FilterStata.dart';
import 'package:silesra/features/Product/presentation/screens/HomePage_Widgets/homewidget.dart';

import 'package:silesra/features/Product/presentation/widgets/custom_bottom_navigation.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_floating_action_button.dart';

import 'package:silesra/features/Service/presentation/service_bloc.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final userService = ListingProvider().userService;
  int _currentIndex = 0;
  bool showFilterDialog = true;
  FilterState _filterState = FilterState(selectedCategory: 'Cars');

  int _notificationCount = 0;

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _filterItems(List<dynamic> items, FilterState filterState) {
    return items.where((item) {
      final matchesPrice = item.price >= filterState.minPrice &&
          item.price <= filterState.maxPrice;
      final matchesSearch = filterState.searchQuery.isEmpty ||
          item.name
              .toLowerCase()
              .contains(filterState.searchQuery.toLowerCase());

      bool matchesCategory = true;
      switch (filterState.selectedCategory) {
        case 'Cars':
          matchesCategory = (filterState.selectedSaleRent == null ||
                  item.sellOrRent == filterState.selectedSaleRent) &&
              (filterState.selectedCarType == null ||
                  item.carType == filterState.selectedCarType) &&
              (filterState.selectedTransmissionType == null ||
                  item.transmissionType ==
                      filterState.selectedTransmissionType) &&
              (filterState.fuelType == null ||
                  item.fuelType == filterState.fuelType);
          break;
        case 'Houses':
          matchesCategory = (filterState.selectedSaleRent == null ||
                  item.sellOrRent == filterState.selectedSaleRent) &&
              (filterState.selectedHouseType == null ||
                  item.houseType == filterState.selectedHouseType);
          break;
        case 'Electronics':
          matchesCategory = (filterState.selectedSaleRent == null ||
                  item.sellOrRent == filterState.selectedSaleRent) &&
              (filterState.electronicsType == null ||
                  item.electronicsType == filterState.electronicsType) &&
              (filterState.selectedCondition == null ||
                  item.condition == filterState.selectedCondition);
          break;
        case 'Fashion':
          matchesCategory = (filterState.selectedSaleRent == null ||
                  item.sellOrRent == filterState.selectedSaleRent) &&
              (filterState.selectedGender == null ||
                  item.gender == filterState.selectedGender) &&
              (filterState.selectedMaterialType == null ||
                  item.material == filterState.selectedMaterialType) &&
              (filterState.selectedSize == null ||
                  item.size == filterState.selectedSize);
          break;
        case 'Job Vacancy':
          matchesCategory = (filterState.selectedJobType == null ||
                  item.positionType == filterState.selectedJobType) &&
              (filterState.selectedjobexperiancelevel == null ||
                  item.experianceLevel ==
                      filterState.selectedjobexperiancelevel);
          break;
        case 'Service':
          matchesCategory =
              (filterState.selectedConsultancyServiceType == null &&
                  item.consultancyServiceType ==
                      filterState.selectedConsultancyServiceType);
          break;

        case 'Accessories':
          matchesCategory = filterState.selectedAccessoryType == null &&
              item.accessoryType == filterState.selectedAccessoryType &&
              (filterState.selectedSaleRent == null ||
                  item.sellOrRent == filterState.selectedSaleRent);

          break;

        default:
          matchesCategory = true;
      }

      return matchesPrice && matchesSearch && matchesCategory;
    }).toList();
  }

  User? _user;
  Timer? _promoTimer;
  late List<NotificationResponse> notifications = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //_loadUser();
    //_fetchDataForCategory('Houses');
    _onCategoryTap('Houses');
    _fetchNotificationCount();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(Duration(seconds: 2), () {
    //     showPromoOverlay(context);
    //   });
    // });

    // _promoTimer = Timer.periodic(Duration(seconds: 10), (_) {
    //   showPromoOverlay(context);
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _promoTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchListings();
      // _fetchDataForCategory('Houses');
      _onCategoryTap('Houses');
    }
  }

  bool isloading = true;
  final BaseService service = BaseService("api");

  Future<void> _fetchListings() async {
    // Check if _user is null
    if (_user == null) {
      print("User data is missing");
      setState(() {
        isloading = false; // Stop loading if there's no user
      });
      return; // Prevent fetching if user is not found
    }

    int? uid = _user!.id;
  }

  void _fetchNotificationCount() {
    // Get the notification bloc.
    context.read<NotificationBloc>().add(NotificationFetchEvent());

    // Listen for changes to the notification state.
    final notificationBloc = context.read<NotificationBloc>();
    // Subscribe to state changes
    notificationBloc.stream.listen((state) {
      if (state is NotificationLoaded) {
        setState(() {
          _notificationCount = state.notifications.length;
          print("Notification count updated: $_notificationCount");
        });
      } else if (state is NotificationError) {
        print("Error fetching notifications: ${state.message}");
      }
    });
  }

  void incrementSeen(String modelname, int productid) async {
    try {
      await service.updateSeenTime(modelname, productid);
    } catch (error) {
      print("Error: $error");
    }
  }

  void _fetchDataForCategory(String category) {
    if (category == 'All') {
      _fetchAllProducts();
    } else if (category == 'Cars') {
      context.read<CarBloc>().add(FetchCars());
    } else if (category == 'Houses') {
      context.read<HouseBloc>().add(FetchHouses());
    } else if (category == 'Lost/Found') {
      context.read<LostOrFoundBloc>().add(FetchLostOrFounds());
    } else if (category == 'Accessory') {
      context.read<AccessoryBloc>().add(AccessoryFetchEvent());
    } else if (category == 'Fashion') {
      context.read<FashionBloc>().add(FetchFashions());
    } else if (category == 'Electronics') {
      context.read<ElectronicsBloc>().add(FetchElectronics());
    } else if (category == 'Job Vacancy') {
      context.read<JobVacancyBloc>().add(FetchJobVacancies());
    } else if (category == 'Services') {
      context
          .read<ServiceOrBusinessTypeBloc>()
          .add(FetchServiceOrBusinessTypes());
    } else if (category == 'Freestaff') {
      context.read<FreestaffBloc>().add(FetchFreestaff());
    } else if (category == 'Other') {
      context.read<OtherItemBloc>().add(FetchOtherItem());
    }
  }

  void _fetchAllProducts() {
    // Dispatch loading for all categories
    context.read<CarBloc>().add(FetchCars());
    context.read<HouseBloc>().add(FetchHouses());
    context.read<JobVacancyBloc>().add(FetchJobVacancies());
    context.read<FashionBloc>().add(FetchFashions());
    context.read<AccessoryBloc>().add(AccessoryFetchEvent());
    context.read<ElectronicsBloc>().add(FetchElectronics());
    context.read<LostOrFoundBloc>().add(FetchLostOrFounds());
    context
        .read<ServiceOrBusinessTypeBloc>()
        .add(FetchServiceOrBusinessTypes());
    context.read<FreestaffBloc>().add(FetchFreestaff());
    context.read<OtherItemBloc>().add(FetchOtherItem());
  }

  void resetFilters() {
    setState(() {
      _filterState =
          FilterState(selectedCategory: _filterState.selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the category is valid before fetching

    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFF8FCFF),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            SizedBox(height: 16),
            _buildCategorySelection(),
            Flexible(
              // Replace Expanded with Flexible
              fit: FlexFit.loose, // Use loose fit
              child: _buildContentBasedOnCategory(),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () => context.go('/terms'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.blue),
                onPressed: () => context.go('/notifications'),
              ),
              if (_notificationCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: const Color(0xFF168AE3)),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  _filterState = _filterState.copyWith(searchQuery: value);
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.currency_exchange, color: const Color(0xFF168AE3)),
            onPressed: () => context.go('/rate'),
          ),
          // SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.filter_list, color: const Color(0xFF168AE3)),
            onPressed:
                showFilterDialog ? () => _showFilterDialog(context) : null,
          ),
          IconButton(
            icon: Icon(Icons.newspaper, color: const Color(0xFF168AE3)),
            // onPressed: () => context.go('/blog'),
            onPressed: () => context.push('/blog'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () => _onCategoryTap(category['label'] as String),
            child: _buildCategory(
              category['color'] as Color,
              category['label'] as String,
              category['icon'] as IconData,
              selected: _filterState.selectedCategory == category['label'],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentBasedOnCategory() {
    if (_filterState.selectedCategory == 'All') {
      return _buildAllProductsContent();
    } else if (_filterState.selectedCategory == 'Cars') {
      return BlocBuilder<CarBloc, CarState>(
        builder: (context, state) {
          if (state is CarLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CarLoaded) {
            if (state.cars.isEmpty) {
              return Center(child: Text('No Car Listings available'));
            }
            return _buildProductGrid(state.cars, 'Cars');
          } else if (state is CarError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Houses') {
      return BlocBuilder<HouseBloc, HouseState>(
        builder: (context, state) {
          if (state is HouseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HouseLoaded) {
            if (state.houses.isEmpty) {
              return Center(child: Text('No House Listing available'));
            }
            return _buildProductGrid(state.houses, 'Houses');
          } else if (state is HouseError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Services') {
      return BlocBuilder<ServiceOrBusinessTypeBloc, ServiceOrBusinessTypeState>(
        builder: (context, state) {
          if (state is ServiceOrBusinessTypeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ServiceOrBusinessTypeLoaded) {
            if (state.serviceOrBusinessTypes.isEmpty) {
              return Center(child: Text('No Service available'));
            }

            return _buildProductGrid(state.serviceOrBusinessTypes, 'Services');
          } else if (state is ServiceOrBusinessTypeError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Lost/Found') {
      return BlocBuilder<LostOrFoundBloc, LostOrFoundState>(
        builder: (context, state) {
          if (state is LostOrFoundLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LostOrFoundLoaded) {
            if (state.lostOrFounds.isEmpty) {
              return Center(child: Text('No lost or found items available'));
            }
            return _buildProductGrid(state.lostOrFounds, 'Lost & Found');
          } else if (state is LostOrFoundError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Accessory') {
      return BlocBuilder<AccessoryBloc, AccessoryState>(
        builder: (context, state) {
          if (state is AccessoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AccessoryLoaded) {
            if (state.accessories.isEmpty) {
              return Center(child: Text('No accessories available'));
            }
            return _buildProductGrid(state.accessories, 'Accessories');
          } else if (state is AccessoryError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Fashion') {
      return BlocBuilder<FashionBloc, FashionState>(
        builder: (context, state) {
          if (state is FashionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FashionLoaded) {
            if (state.fashions.isEmpty) {
              return Center(child: Text('No fashion items available'));
            }
            return _buildProductGrid(state.fashions, 'Fashion');
          } else if (state is FashionError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Electronics') {
      return BlocBuilder<ElectronicsBloc, ElectronicsState>(
        builder: (context, state) {
          if (state is ElectronicsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ElectronicsLoaded) {
            if (state.electronics.isEmpty) {
              return Center(child: Text('No electronics available'));
            }
            return _buildProductGrid(state.electronics, 'Electronics');
          } else if (state is ElectronicsError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Freestaff') {
      print("%%%%%   Frees staff at home page ");
      return BlocBuilder<FreestaffBloc, FreestaffState>(
        builder: (context, state) {
          print("%%%%% Returned state   Frees staff at home page $state");
          if (state is FreestaffLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FreestaffLoaded) {
            print("%%%%% Returned state   Frees staff at home page ");
            if (state.freestaff.isEmpty) {
              return Center(child: Text('No Free Staff available'));
            }
            return _buildProductGrid(state.freestaff, 'FreeStaff');
          } else if (state is FreestaffError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Other') {
      return BlocBuilder<OtherItemBloc, OtherItemState>(
        builder: (context, state) {
          if (state is OtherItemLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OtherItemLoaded) {
            if (state.items.isEmpty) {
              return Center(child: Text('No Free Staff available'));
            }
            return _buildProductGrid(state.items, 'Other');
          } else if (state is OtherItemError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else if (_filterState.selectedCategory == 'Job Vacancy') {
      return BlocBuilder<JobVacancyBloc, JobVacancyState>(
        builder: (context, state) {
          if (state is JobVacancyLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is JobVacancyLoaded) {
            if (state.jobVacancies.isEmpty) {
              return Center(child: Text('No job vacancies available'));
            }

            return _buildProductGrid(state.jobVacancies, 'Job Vacancy');
          } else if (state is JobVacancyError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      );
    } else {
      return Center(
          child:
              Text('No data available for ${_filterState.selectedCategory}'));
    }
  }

  // build all product home page
  Widget _buildAllProductsContent() {
    return SingleChildScrollView(
      child: MultiBlocListener(
        listeners: [
          BlocListener<CarBloc, CarState>(
            listener: (context, state) {
              if (state is CarError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error loading cars: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<HouseBloc, HouseState>(
            listener: (context, state) {
              if (state is HouseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error loading houses: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<JobVacancyBloc, JobVacancyState>(
            listener: (context, state) {
              if (state is JobVacancyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error loading jobs: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<FashionBloc, FashionState>(
            listener: (context, state) {
              if (state is FashionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error loading fashion: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<AccessoryBloc, AccessoryState>(
            listener: (context, state) {
              if (state is AccessoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Error loading accessories: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<ElectronicsBloc, ElectronicsState>(
            listener: (context, state) {
              if (state is ElectronicsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Error loading electronics: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<LostOrFoundBloc, LostOrFoundState>(
            listener: (context, state) {
              if (state is LostOrFoundError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Error loading lost or found: ${state.message}')),
                );
              }
            },
          ),
          BlocListener<ServiceOrBusinessTypeBloc, ServiceOrBusinessTypeState>(
            listener: (context, state) {
              if (state is ServiceOrBusinessTypeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Error loading services: ${state.message}')),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<CarBloc, CarState>(
              builder: (context, state) {
                // if (state is CarLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is CarLoaded) {
                  return _buildProductGrid(state.cars, 'Cars');
                }
                return Container();
              },
            ),
            BlocBuilder<HouseBloc, HouseState>(
              builder: (context, state) {
                if (state is HouseLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is HouseLoaded) {
                  return _buildProductGrid(state.houses, 'Houses');
                }
                return Container();
              },
            ),
            BlocBuilder<JobVacancyBloc, JobVacancyState>(
              builder: (context, state) {
                // if (state is JobVacancyLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is JobVacancyLoaded) {
                  return _buildProductGrid(state.jobVacancies, 'Jobs');
                }
                return Container();
              },
            ),
            BlocBuilder<FashionBloc, FashionState>(
              builder: (context, state) {
                // if (state is FashionLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is FashionLoaded) {
                  return _buildProductGrid(state.fashions, 'Fashion');
                }
                return Container();
              },
            ),
            BlocBuilder<AccessoryBloc, AccessoryState>(
              builder: (context, state) {
                // if (state is AccessoryLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is AccessoryLoaded) {
                  return _buildProductGrid(state.accessories, 'Accessories');
                }
                return Container();
              },
            ),
            BlocBuilder<ElectronicsBloc, ElectronicsState>(
              builder: (context, state) {
                // if (state is ElectronicsLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is ElectronicsLoaded) {
                  return _buildProductGrid(state.electronics, 'Electronics');
                }
                return Container();
              },
            ),
            BlocBuilder<LostOrFoundBloc, LostOrFoundState>(
              builder: (context, state) {
                // if (state is LostOrFoundLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is LostOrFoundLoaded) {
                  return _buildProductGrid(state.lostOrFounds, 'Lost & Found');
                }
                return Container();
              },
            ),
            BlocBuilder<FreestaffBloc, FreestaffState>(
              builder: (context, state) {
                if (state is FreestaffLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loader when fetching data
                }
                if (state is FreestaffLoaded) {
                  // Ensure class name matches your state
                  return _buildProductGrid(state.freestaff,
                      'Freestaff'); // Show grid when data is loaded
                }
                if (state is FreestaffError) {
                  return Center(
                      child: Text('Error: ${state.message}',
                          style: TextStyle(
                              color: Colors.red))); // Show error message
                }
                return Container(); // Default fallback
              },
            ),
            BlocBuilder<ServiceOrBusinessTypeBloc, ServiceOrBusinessTypeState>(
              builder: (context, state) {
                // if (state is ServiceOrBusinessTypeLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                if (state is ServiceOrBusinessTypeLoaded) {
                  return _buildProductGrid(
                      state.serviceOrBusinessTypes, 'Services');
                }
                return Container();
              },
            ),
            BlocBuilder<OtherItemBloc, OtherItemState>(
              builder: (context, state) {
                if (state is OtherItemLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loader when fetching data
                }
                if (state is OtherItemLoaded) {
                  // Ensure class name matches your state
                  return _buildProductGrid(
                      state.items, 'Other'); // Show grid when data is loaded
                }
                if (state is OtherItemError) {
                  return Center(
                      child: Text('Error: ${state.message}',
                          style: TextStyle(
                              color: Colors.red))); // Show error message
                }
                return Container(); // Default fallback
              },
            ),
          ],
        ),
      ),
    );
  }

//all catageory build on home page
  Widget _buildProductGrid(List<dynamic> products, String category) {
    final filteredProducts = _filterItems(products, _filterState);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Handle load more for both horizontal (All) and vertical lists
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreData(category);
        }
        return false;
      },
      child: _filterState.selectedCategory == 'All'
          ? SizedBox(
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Specific listener for horizontal scrolling
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          _loadMoreData(category);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredProducts.length +
                            (_shouldShowLoading(category) ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= filteredProducts.length) {
                            return _buildHorizontalLoadingIndicator(category);
                          }
                          final product = filteredProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 200,
                              child: _buildItemCard(product, category),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                if (filteredProducts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No ${category.toLowerCase()} found matching your filters',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == filteredProducts.length) {
                            return _buildLoadingIndicator(category);
                          }
                          final product = filteredProducts[index];
                          return _buildItemCard(product, category);
                        },
                        childCount: filteredProducts.length +
                            (_shouldShowLoading(category) ? 1 : 0),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildHorizontalLoadingIndicator(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: _shouldShowLoading(category)
            ? CircularProgressIndicator()
            : Text('No more items', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  bool _shouldShowLoading(String category) {
    switch (category) {
      case 'Houses':
        final state = context.read<HouseBloc>().state;
        return state is HouseLoaded && !state.hasReachedMax;
      case 'Cars':
        final state = context.read<CarBloc>().state;
        return state is CarLoaded && !state.hasReachedMax;
      case 'Jobs':
        final state = context.read<JobVacancyBloc>().state;
        return state is JobVacancyLoaded && !state.hasReachedMax;
      // Add other categories as needed
      default:
        return false;
    }
  }

  void _loadMoreData(String category) {
    switch (category) {
      case 'Houses':
        final houseState = context.read<HouseBloc>().state;
        if (houseState is HouseLoaded && !houseState.hasReachedMax) {
          context.read<HouseBloc>().add(FetchMoreHouses());
        }
        break;
      case 'Cars':
        final carState = context.read<CarBloc>().state;
        if (carState is CarLoaded && !carState.hasReachedMax) {
          context.read<CarBloc>().add(FetchMoreCars());
        }
        break;
      case 'Fashions':
        final fashionState = context.read<FashionBloc>().state;
        if (fashionState is FashionLoaded && !fashionState.hasReachedMax) {
          context.read<FashionBloc>().add(FetchMoreFashions());
        }
        break;
      case 'Accessory':
        final accessoryState = context.read<AccessoryBloc>().state;
        if (accessoryState is AccessoryLoaded &&
            !accessoryState.hasReachedMax) {
          context.read<AccessoryBloc>().add(FetchMoreAccessories());
        }
        break;
      case 'Electronics':
        final accessoryState = context.read<ElectronicsBloc>().state;
        if (accessoryState is ElectronicsLoaded &&
            !accessoryState.hasReachedMax) {
          context.read<ElectronicsBloc>().add(FetchMoreElectronics());
        }
        break;
      case 'Lost/Found':
        final lostorfoundstate = context.read<LostOrFoundBloc>().state;
        if (lostorfoundstate is LostOrFoundLoaded &&
            !lostorfoundstate.hasReachedMax) {
          context.read<LostOrFoundBloc>().add(FetchMoreLostOrFounds());
        }
      case 'Jobs':
        final jobState = context.read<JobVacancyBloc>().state;
        if (jobState is JobVacancyLoaded && !jobState.hasReachedMax) {
          context.read<JobVacancyBloc>().add(FetchMoreJobVacancies());
        }
        break;
      case 'Freestaff':
        final freestaffState = context.read<FreestaffBloc>().state;
        if (freestaffState is FreestaffLoaded &&
            !freestaffState.hasReachedMax) {
          context.read<FreestaffBloc>().add(FetchMoreFreestaff());
        }
        break;

      case 'Other':
        final otherState = context.read<OtherItemBloc>().state;
        if (otherState is OtherItemLoaded && !otherState.hasReachedMax) {
          context.read<OtherItemBloc>().add(FetchMoreOtherItems());
        }
        break;
      default:
        break;
    }
  }

  Widget _buildLoadingIndicator(String category) {
    switch (category) {
      case 'Houses':
        final houseState = context.read<HouseBloc>().state;
        if (houseState is HouseLoaded && !houseState.hasReachedMax) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        break;
      case 'Cars':
        final carState = context.read<CarBloc>().state;
        if (carState is CarLoaded && !carState.hasReachedMax) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        break;
      case 'Jobs':
        final jobState = context.read<JobVacancyBloc>().state;
        if (jobState is JobVacancyLoaded && !jobState.hasReachedMax) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        break;
      default:
        break;
    }
    return SizedBox.shrink();
  }

  Widget _buildItemCard(dynamic product, String catagory) {
    String currcatagory = _filterState.selectedCategory;

    return GestureDetector(
      onTap: () {
        String categoryName = product.category["name"];
        incrementSeen(categoryName, product.id);
        GoRouter.of(context).push('/detail', extra: {'product': product});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: _filterState.selectedCategory == 'All' ? 170 : 200,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: product.images.isNotEmpty &&
                        File(product.images[0]).existsSync()
                    ? Image.file(
                        File(product.images[0]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.asset(
                        'assets/placeholder.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            // Scrollable content section
            Flexible(
              // <--- Add this if you're inside a Column
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            getProductTitle(product),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Price + Sale/Rent row
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            getProductPrice(product),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          flex: 1,
                          child: Text(
                            getSaleOrRent(product),
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Add more content here as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategoryTap(String title) {
    setState(() {
      if (FilterDialogNoNeed.contains(title)) {
        showFilterDialog = false;
      } else {
        showFilterDialog = true;
      }

      _filterState = _filterState.copyWith(selectedCategory: title);
    });
    _fetchDataForCategory(title);
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/wishlist');
        break;
      case 2:
        context.go('/messages');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter ${_filterState.selectedCategory}",
                    style: TextStyle(
                      color: Color(0xFF168AE3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      resetFilters();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price Range

                    _buildSaleOrrent(setState),
                    _buildPriceRange(setState, context),
                    _buildCategoryFilters(setState),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF168AE3)),
                  ),
                  onPressed: () {
                    resetFilters();
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Color(0xFF168AE3)),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFF168AE3),
                  ),
                  onPressed: () {
                    this.setState(() {}); // Apply new filters
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSaleOrrent(void Function(void Function()) setState) {
    return (FilterDialogNoNeed.contains(_filterState.selectedCategory) ||
            _filterState.selectedCategory != 'Job')
        ? SizedBox.shrink() //only House,Car.....
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sale/Rent",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RadioListTile<String>(
                        title: Text(
                          'Sale',
                          style: TextStyle(
                              color: Colors.black), // Text color set to black
                        ),
                        value: 'Sale',
                        groupValue: _filterState.selectedSaleRent,
                        dense: true,
                        activeColor: Color(
                            0xFF168AE3), // Radio button color when selected
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        onChanged: (value) {
                          setState(() {
                            _filterState = _filterState.copyWith(
                              selectedSaleRent: value,
                            );
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        title: Text(
                          'Rent',
                          style: TextStyle(
                              color: Colors.black), // Text color set to black
                        ),
                        value: 'Rent',
                        groupValue: _filterState.selectedSaleRent,
                        dense: true,
                        activeColor: Color(
                            0xFF168AE3), // Radio button color when selected
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        onChanged: (value) {
                          setState(() {
                            _filterState = _filterState.copyWith(
                              selectedSaleRent: value,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          );
  }

  Widget _buildPriceRange(
      void Function(void Function()) setState, BuildContext context) {
    final numberFormat =
        NumberFormat("#,##0", "en_US"); // Format numbers with commas

    // Clamp the values to be within the min and max range
    double minPrice = _filterState.minPrice < 1 ? 1 : _filterState.minPrice;
    double maxPrice =
        _filterState.maxPrice > 99000000 ? 99000000 : _filterState.maxPrice;

    return (FilterDialogNoNeed.contains(_filterState.selectedCategory) ||
            _filterState.selectedCategory != 'Job')
        ? SizedBox.shrink() //only House,Car.....
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Price Range",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  sliderTheme: SliderThemeData(
                    rangeValueIndicatorShape:
                        PaddleRangeSliderValueIndicatorShape(),
                    showValueIndicator: ShowValueIndicator.always,
                    valueIndicatorColor: Color(0xFF168AE3),
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                child: RangeSlider(
                  values: RangeValues(
                    _filterState.minPrice
                        .clamp(0, 1000000), // Ensures minPrice is within range
                    _filterState.maxPrice
                        .clamp(0, 1000000), // Ensures maxPrice is within range
                  ),
                  min: 0,
                  max: 1000000,
                  divisions: 100,
                  labels: RangeLabels(
                    "${numberFormat.format(_filterState.minPrice.toInt())} Birr",
                    "${numberFormat.format(_filterState.maxPrice.toInt())} Birr",
                  ),
                  activeColor: Color(0xFF168AE3),
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (values) {
                    if (values.start <= values.end) {
                      setState(() {
                        _filterState = _filterState.copyWith(
                          minPrice: values.start,
                          maxPrice: values.end,
                        );
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
            ],
          );
  }

// Function to build category-specific filters
  Widget _buildCategoryFilters(void Function(void Function()) setState) {
    switch (_filterState.selectedCategory) {
      case 'Cars':
        return Column(
          children: [
            _buildDropdown(
              "Car Type",
              _filterState.selectedCarType,
              carTypes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(selectedCarType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Transmission",
              _filterState.selectedTransmissionType,
              transmissiontypes,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedTransmissionType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Fule Type",
              _filterState.fuelType,
              carFuelTypes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(fuelType: value);
                });
              },
            ),
          ],
        );

      case 'Houses':
        return _buildDropdown(
          "House Type",
          _filterState.selectedHouseType,
          houseTypes,
          (value) {
            setState(() {
              _filterState = _filterState.copyWith(selectedHouseType: value);
            });
          },
        );
      case 'Electronics':
        return Column(
          children: [
            _buildDropdown(
              "Electronics Type",
              _filterState.electronicsType,
              electronicsTypes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(electronicsType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Condition",
              _filterState.selectedCondition,
              conditions,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedCondition: value);
                });
              },
            ),
          ],
        );

      case 'Fashion':
        return Column(
          children: [
            _buildDropdown(
              "Gender",
              _filterState.selectedGender,
              genders,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(selectedGender: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Material",
              _filterState.selectedMaterialType,
              materials,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedMaterialType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Size",
              _filterState.selectedSize,
              sizes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(selectedSize: value);
                });
              },
            ),
          ],
        );
      case 'Accessory':
        return Column(
          children: [
            _buildDropdown(
              "Type",
              _filterState.selectedAccessoryType,
              accessoryTypes,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedAccessoryType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Condition",
              _filterState.selectedCondition,
              conditions,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedCondition: value);
                });
              },
            ),
          ],
        );
      case 'Job Vacancy':
        return Column(
          children: [
            _buildDropdown(
              "Job Type",
              _filterState.selectedJobType,
              jobTypes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(selectedJobType: value);
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdown(
              "Experiance Level ",
              _filterState.selectedjobexperiancelevel,
              experienceLevels,
              (value) {
                setState(() {
                  _filterState =
                      _filterState.copyWith(selectedjobexperiancelevel: value);
                });
              },
            ),
          ],
        );
      case 'Service':
        return Column(
          children: [
            _buildDropdown(
              "Service Type",
              _filterState.selectedConsultancyServiceType,
              serviceTypes,
              (value) {
                setState(() {
                  _filterState = _filterState.copyWith(
                      selectedConsultancyServiceType: value);
                });
              },
            ),
            SizedBox(height: 16),
          ],
        );

      default:
        return SizedBox
            .shrink(); // If no matching category, return an empty widget
    }
  }

// Helper function for dropdown fields
  Widget _buildDropdown(String label, String? selectedValue,
      List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration:
              _inputDecoration("Select $label"), // Removed suffixIcon here
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down,
              color: Colors.grey), // Custom icon here
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategory(Color color, String title, IconData icon,
      {bool selected = false}) {
    // Derive a darker version of the background color by using full opacity
    Color darkerColor = Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      1.0, // Full opacity for a darker, solid version
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: selected ? const Color(0xFF168AE3) : color,
            radius: 28,
            child: Icon(
              icon,
              color: selected
                  ? Colors.white
                  : darkerColor, // Use darker color when not selected
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: selected ? const Color(0xFF168AE3) : Colors.grey.shade600,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.grey[850], fontSize: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFF168AE3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFF168AE3)),
      ),
    );
  }
}
