// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:silesra/features/Accessory/data/accessory_model.dart';
import 'package:silesra/features/Auth/models/user_model.dart';

import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Electronics/data/model/electronics_model.dart';
import 'package:silesra/features/Fashion/data/model/fashion_model.dart';
import 'package:silesra/features/FreeStuff/data/model/free_stuff_model.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/Job/data/model/job_vacancy.dart';
import 'package:silesra/features/LOF/data/model/lof_model.dart';
import 'package:silesra/features/OtherItems/data/model/otheritem_model.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Product/presentation/widgets/full_screen_image_viewer.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_bloc.dart';
import 'package:silesra/features/Watchlist/bloc/watchlist_event.dart';
import 'package:silesra/features/Watchlist/data/model/watch_list_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final dynamic product;

  const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final watchListService = ListingProvider().watchlistService;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavourite;
  }

  final Set<int> _pendingFavorities =
      {}; // Keep track of pending favorite items

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(" %%%%%  didChangeDependencies $_pendingFavorities");
      if (_pendingFavorities.isNotEmpty) {
        _insertPendingNotifications();
      }
    });
  }

  Future<void> _insertPendingNotifications() async {
    for (var id in _pendingFavorities) {
      await insertNotification();
    }
    _pendingFavorities.clear(); // Clear after processing
  }

  Future<void> insertNotification() async {
    final user = Provider.of<UserBloc>(context, listen: false); // FIXED

    final userState = user.state;
    final userId = (userState is UserLoaded) ? userState.user.id : null;

    if (userId == null) return;

    try {
      final formData = {
        'user': userId,
        'objectId': widget.product.id,
        'contentType': widget.product.contentType,
      };

      await watchListService.create(formData, Watchlist.from_dict, 'watchlist');

      // setState(() {
      //   isFavorite = !isFavorite; // Toggle State
      // });
    } catch (e) {
      print(e);
    }
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      print("%%%% is Favouriete called $isFavorite");
      _pendingFavorities.add(widget.product.id);
      print("%%%% after addedd called $_pendingFavorities");
    } else {
      _pendingFavorities.remove(widget.product.id);
    }
  }

  void _callAdvertiser(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

  String timeAgo(DateTime createdAt) {
    DateTime createdTime = createdAt.toLocal(); // Convert to local time
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
    } else {
      return DateFormat('MMM d, yyyy')
          .format(createdTime); // Example: "Feb 6, 2025"
    }
  }

  // Function to message the advertiser
  void _messageAdvertiser(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      debugPrint('Could not launch $smsUri');
    }
  }

  void goTochatPage(BuildContext context, String path, int itemid,
      dynamic product, int currentuid, String firstname, String token) {
    final postedById = widget.product.postedby?['id'];
    final categoryId = widget.product.contentType;
    print(" %%%%%%%%% I will crate room by  Contectn Type $categoryId");
    if (postedById == null || categoryId == null) {
      print("Error: Product is missing required fields.");
      return;
    }

    // Debugging prints

    // Navigate safely
    GoRouter.of(context).go(
        '$path?&objectid=$itemid&sender_id=$currentuid&username=$firstname'
        '&seller_id=$postedById&contenttype_id=$categoryId&product=$product&token=$token');
  }

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final postedById = widget.product.postedby['id']; // Get postedBy ID

    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);

    return Scaffold(
      backgroundColor: Color(0xFFF8FCFF),
      appBar: AppBar(
        title: Text(
          widget.product.category['name'] ?? 'Product Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _insertPendingNotifications(); // Ensure pending deletions are processed
              if (mounted) {
                Navigator.pop(context);
              }
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.yellow[700] : Colors.grey[400],
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          // Carousel View
          SizedBox(
            height: 260, // Increased height slightly to accommodate indicator
            child: Column(
              children: [
                SizedBox(
                  height: 240,
                  child: PageView.builder(
                    controller: _pageController, // Add controller
                    itemCount: widget.product.images.length,
                    itemBuilder: (context, index) {
                      final image = widget.product.images[index];
                      String imagePath;

                      if (image is String) {
                        // If image is a String, use it directly
                        imagePath = image;
                      } else if (image is Map<String, dynamic>) {
                        // If image is a Map, extract the 'imagepath' key
                        imagePath = image['imagepath'] as String;
                      } else {
                        // Handle unexpected types (fallback to a placeholder)
                        imagePath = 'assets/placeholder.png';
                      }
                      return GestureDetector(
                        onTap: () {
                          // Show full-screen image viewer with zoom
                          List<String> imagePaths =
                              widget.product.images.map<String>((item) {
                            if (item is String) {
                              return item; // Use the string directly
                            } else if (item is Map<String, dynamic>) {
                              return item['imagepath'] as String? ??
                                  'assets/placeholder.png'; // Extract 'imagepath' with a fallback
                            } else {
                              return 'assets/placeholder.png'; // Fallback for invalid types
                            }
                          }).toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageViewer(
                                images: imagePaths,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Align(
                            alignment: Alignment
                                .center, // Change to Alignment.topCenter if needed
                            child: File(imagePath).existsSync()
                                ? Image.file(
                                    File(imagePath),
                                    fit: BoxFit
                                        .cover, // Keeps it large but fills the container
                                    width: double.infinity,
                                    height: double.maxFinite,
                                  )
                                : Image.asset(
                                    'assets/placeholder.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Smooth Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.product.images.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Color(0xFF168AE3),
                    dotColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),

          // DraggableScrollableSheet below the Carousel
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize:
                  0.95, // Initial size of the sheet (50% of the remaining space)
              minChildSize:
                  0.95, // Minimum size of the sheet (25% of the remaining space)
              maxChildSize:
                  1.0, // Maximum size of the sheet (90% of the remaining space)
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller:
                      scrollController, // Use the provided scroll controller
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title & Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Advertiser:',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.product.phonenumber ?? 'Not available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color(0xFF168AE3),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.product is! JobVacancyModel)
                              Text(
                                '${widget.product.price.toInt().toString() ?? 0.0} ብር',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF168AE3),
                                ),
                              ),
                            if (widget.product is JobVacancyModel)
                              Text(
                                '${widget.product.salary.toInt().toString() ?? 0.0}  ብር',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF168AE3),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Advertiser & Views (Moved Advertiser up)
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Posted:  ',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF168AE3),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: timeAgo(widget.product.created),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.remove_red_eye,
                                size: 18, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                              (widget.product?.seen != null
                                  ? widget.product!.seen!.toInt().toString()
                                  : '0'),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Product Details
                        Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.all(20),
                          child: _buildDynamicProductDetails(),
                        ),

                        // Description above Call & Phone
                        // Divider above the Description
                        Divider(
                          thickness: 2, // Thickness of the divider
                          color: Colors.grey[300], // Color of the divider
                          indent: 20, // Indent from the left
                          endIndent: 20, // Indent from the right
                        ),

// Description Text
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Text(
                            'Description',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

// JOb Description
                        if (widget.product is JobVacancyModel) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Text(
                              (widget.product as JobVacancyModel)
                                      .JobDescription ??
                                  'No job description available',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height:
                                    1.5, // Line height for better readability
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: Text(
                              'Job Requirment',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Text(
                              (widget.product as JobVacancyModel)
                                      .JobRequirment ??
                                  'No job requirement available',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height:
                                    1.5, // Line height for better readability
                              ),
                            ),
                          ),
                        ],
                        if (widget.product is! JobVacancyModel)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            child: Text(
                              widget.product.description ??
                                  'No description   available',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height:
                                    1.5, // Line height for better readability
                              ),
                            ),
                          ),

// Divider below the Description
                        Divider(
                          thickness: 2, // Thickness of the divider
                          color: Colors.grey[300], // Color of the divider
                          indent: 20, // Indent from the left
                          endIndent: 20, // Indent from the right
                        ),

                        const SizedBox(height: 8),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              onPressed: widget.product.phonenumber != null
                                  ? () => _callAdvertiser(
                                      widget.product.phonenumber!)
                                  : null,
                              icon: Icon(Icons.call, color: Color(0xFF168AE3)),
                              label: Text(
                                'Call',
                                style: GoogleFonts.poppins(
                                    color: Color(0xFF168AE3)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Color(0xFF168AE3)),
                                backgroundColor: Color(0xFFF8FCFF),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12), // Reduced horizontal padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: widget.product.phonenumber != null
                                  ? () => _messageAdvertiser(
                                      widget.product.phonenumber!)
                                  : null,
                              icon: Icon(Icons.message, color: Colors.white),
                              label: Text(
                                'Message',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF168AE3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12), // Reduced horizontal padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserLoading) {
                                  return Center(
                                      child:
                                          CircularProgressIndicator()); // 🔄 Show loading
                                }

                                if (state is UserError) {
                                  return Center(
                                      child: Text(
                                          'Failed to load user info')); // ❌ Handle error
                                }

                                if (state is UserLoaded) {
                                  final loggedInUserId =
                                      state.user.id; // Get logged-in user ID
                                  print(
                                      "%%%%%%%%%%%%% chat check up Posted by $postedById and current user $loggedInUserId");
                                  // Show chat button only if the logged-in user is NOT the poster
                                  if (postedById != null &&
                                      postedById != loggedInUserId) {
                                    return ElevatedButton.icon(
                                      onPressed:
                                          widget.product.phonenumber != null
                                              ? () => goTochatPage(
                                                  context,
                                                  '/chat',
                                                  widget.product.id,
                                                  widget.product,
                                                  user!.id!,
                                                  user.firstName,
                                                  user.accessToken)
                                              : null,
                                      icon: Icon(Icons.message,
                                          color: Colors.white),
                                      label: Text(
                                        'Chat',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF168AE3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                }

                                return SizedBox
                                    .shrink(); // Hide if no valid state
                              },
                            ),
                          ],
                        ),
// Add spacing after the Row if needed
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicProductDetails() {
    if (widget.product is HouseModel) {
      return _buildHouseDetails(widget.product as HouseModel);
    }
    if (widget.product is CarModel) {
      return _buildCarDetails(widget.product as CarModel);
    }
    if (widget.product is JobVacancyModel) {
      return _buildJobDetails(widget.product as JobVacancyModel);
    }
    if (widget.product is LostOrFound) {
      return _buildLOFDetails(widget.product as LostOrFound);
    }
    if (widget.product is OtherItem) {
      return _buildOtherItemDetails(widget.product as OtherItem);
    }
    if (widget.product is AccessoryModel) {
      return _buildAccessoryDetails(widget.product as AccessoryModel);
    }
    if (widget.product is FashionModel) {
      return _buildFashionDetails(widget.product as FashionModel);
    }
    if (widget.product is ElectronicsModel) {
      return _buildElectronicsDetails(widget.product as ElectronicsModel);
    }
    if (widget.product is FreeStaffOrItem) {
      return _buildFreeStuffDetails(widget.product as FreeStaffOrItem);
    }

    return Text(
      'No specific details available',
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
    );
  }

// 🔹 Accessory Details
  Widget _buildAccessoryDetails(AccessoryModel accessory) {
    return _buildDetailGrid({
      'Area': accessory.city ?? 'N/A',
      'Type': accessory.accessoryType ?? 'N/A',
      'Condition': accessory.condition ?? 'N/A',
      'Brand': accessory.brand ?? 'N/A',
      'Sell/Rent': accessory.sellOrRent ?? 'N/A',
    });
  }

// 🔹 Fashion Details
  Widget _buildFashionDetails(FashionModel fashion) {
    print(fashion);
    return _buildDetailGrid({
      'Area': fashion.city ?? 'N/A',
      'Fashion Type': fashion.fashionType ?? 'N/A',
      'Gender': fashion.gender ?? 'N/A',
      'Size': fashion.size ?? 'N/A',
      'Material': fashion.material ?? 'N/A',
      'Condition': fashion.condition ?? 'N/A',
      'Sell/Rent': fashion.sellOrRent ?? 'N/A',
      'Brand': fashion.brand ?? 'N/A',
    });
  }

// 🔹 Electronics Details
  Widget _buildElectronicsDetails(ElectronicsModel electronics) {
    return _buildDetailGrid({
      'Area': electronics.city ?? 'N/A',
      'Electronics Type': electronics.electronicsType ?? 'N/A',
      'Brand': electronics.brand ?? 'N/A',
      'Model': electronics.model ?? 'N/A',
      'Condition': electronics.condition ?? 'N/A',
      'Warranty': electronics.warranty ?? 'N/A',
      'Sell/Rent': electronics.sellOrRent ?? 'N/A',
    });
  }

// 🔹 FreeStuff Details
  Widget _buildFreeStuffDetails(FreeStaffOrItem freeStaff) {
    return _buildDetailGrid({
      'Area': freeStaff.city ?? 'N/A',
      'Title': freeStaff.title ?? 'N/A',
      'Description': freeStaff.description ?? 'N/A',
    });
  }

// 🔹 House Details
  Widget _buildHouseDetails(HouseModel house) {
    return _buildDetailGrid({
      'Area': house.city ?? 'N/A',
      'Bedroom': house.numberofBedrooms.toString(),
      'Bathroom': house.numberofBathrooms.toString(),
      'Size': house.area ?? 'N/A',
      'Type': house.houseType ?? 'N/A',
    });
  }

// 🔹 Car Details
  Widget _buildCarDetails(CarModel car) {
    return _buildDetailGrid({
      'Area': car.city ?? 'N/A',
      'Make': car.carType?['name'] ?? 'N/A',
      'Model': car.model ?? 'N/A',
      'Mileage': car.mileage ?? 'N/A',
      'Fuel': car.fuelType ?? 'N/A',
      'year of Make': car.yearofMake ?? 'N/A',
      'Transmission': car.transmission ?? 'N/A',
      'License': car.license ?? 'N/A',
    });
  }

  Widget _buildJobDetails(JobVacancyModel job) {
    return _buildDetailGrid({
      'Area': job.city ?? 'N/A',
      'Company': job.companyName ?? 'N/A',
      'Position': job.positionTitle ?? 'N/A',
      'Type': job.positionType ?? 'N/A',
      'Location': job.worklocation ?? 'N/A',
      'salary': '${job!.salary!.toInt()} ብር' ?? 'N/A',
      'Deadline':
          job.applicationDeadline.toLocal().toIso8601String().split('T')[0] ??
              'N/A',
    });
  }

  Widget _buildOtherDetails(OtherItem job) {
    return _buildDetailGrid({
      'Area': job.city ?? 'N/A',
      'name': job.name ?? 'N/A',
      'Service Type': job.otherItemcategory?["name"] ?? 'N/A',
      'for': job.sellOrRent ?? 'N/A',
    });
  }

  Widget _buildLostorfoundDetails(LostOrFound job) {
    return _buildDetailGrid({
      'Area': job.city ?? 'N/A',
      'Item': job.title ?? 'N/A',
      'case?': job.typeofadd ?? 'N/A',
    });
  }

// 🔹 Detail Grid for House & Car (Fix: Each Item is Styled Individually)
  Widget _buildDetailGrid(Map<String, String> details) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: details.entries
          .map(
            (e) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    Color(0xFF168AE3).withOpacity(0.1), // ✅ Correct Background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${e.key}: ${e.value}',
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }

// 🔹 Lost or Found Details
  Widget _buildLOFDetails(LostOrFound lof) {
    return Column(
      children: [
        _buildLostorfoundDetails(lof),
      ],
    );
  }

// 🔹 Other Item Details
  Widget _buildOtherItemDetails(OtherItem other) {
    return Column(
      children: [
        _buildOtherDetails(other),
      ],
    );
  }
}
