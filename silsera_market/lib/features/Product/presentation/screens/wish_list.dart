import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Cars/data/models/car_model.dart';
import 'package:silesra/features/Cars/domain/entity/car_entitiy.dart';
import 'package:silesra/features/House/data/model/house_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Product/data/models/product_model.dart';

import 'package:silesra/features/Product/presentation/widgets/custom_bottom_navigation.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_floating_action_button.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var watchlistdata = [];
  int _currentIndex = 3; // Profile is the third tab
  User? _user;
  // int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingDeletes.isNotEmpty) {
        _deletePendingNotifications();
      }
    });
  }

  final BaseService service = BaseService("watchlist");
  final Set<int> _pendingDeletes = {};
  Future<void> _deletePendingNotifications() async {
    for (var id in _pendingDeletes) {
      await _deleteNotification(id);
    }
    _pendingDeletes.clear();
  }

  Future<void> _gottoDetailPage(String modelname, int itemid) async {
    try {
      // Fetch the data and map it to the appropriate model
      BaseListing product = await service.getSingleModelData(itemid, modelname);
      print("   ======>   Go to Detail page ");
      GoRouter.of(context).push('/detail', extra: {'product': product});
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error navigating to detail page: $e");
    }
  }

  Future<void> _deleteNotification(int notificationId) async {
    final listingProvider =
        Provider.of<ListingProvider>(context, listen: false);
    print(" %%%% I will delete this list $notificationId ");
    await listingProvider.watchlistService.delete('watchlist', notificationId);
  }

  bool isloading = true;

  String timeAgo(DateTime createdAt) {
    DateTime createdTime = createdAt.toLocal();
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} hours ago";
    } else {
      return DateFormat('MMM d, yyyy').format(createdTime);
    }
  }

  Future<void> _fetchListings() async {
    final listingProvider =
        Provider.of<ListingProvider>(context, listen: false);

    try {
      List<WatchlistResponse> items =
          await listingProvider.watchlistService.fetcWatchListItems();
      setState(() {
        watchlistdata = items;
        isloading = false;
      });
      // Debug: Print categories to verify
      for (var item in items) {
        print("Item: ${item.name}, Category: ${item.category}");
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("Error fetching posted items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        title: const Text('Watchlist'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _deletePendingNotifications(); // Ensure pending deletions are processed
              if (mounted) {
                context.go('/home');
              }
            }),
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : watchlistdata.isEmpty
              ? Center(
                  child: Text(
                    "No items found in your watchlist.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  itemCount: watchlistdata.length,
                  itemBuilder: (context, index) {
                    final item = watchlistdata[index];

                    return Dismissible(
                      key: Key(item.id.toString()), // Use a unique key
                      direction: DismissDirection
                          .endToStart, // Swipe from right to left
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Handle item removal
                        setState(() {
                          _pendingDeletes.add(item.id);
                          watchlistdata.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${getProductTitle(item)} removed')),
                        );
                      },
                      child: InkWell(
                        onTap: () =>
                            _gottoDetailPage(item.category['api'], item.itemId),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: parseColor(item.category?['color'] ??
                                        "rgba(76, 175, 80, 0.2)"),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(21, 138, 226, 1),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    getCategoryIcon(
                                        item.category['icon'] ?? 'more_horiz'),
                                    size: 30,
                                    color:
                                        const Color.fromRGBO(21, 138, 226, 1),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              getProductTitle(item),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'watched: ',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF168AE3),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: timeAgo(item.created),
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.yellow[700],
                                size: 20,
                              ),
                              onPressed: () => _gottoDetailPage(
                                  item.category['api'], item.itemId),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // Handle FAB press
          context.go('/terms');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            case 4:
              context.go('/chat');
              break;
          }
        },
      ),
    );
  }
  //   Widget _buildDynamicProductDetails() {
  //   if (widget.product is HouseModel)
  //     return _buildHouseDetails(widget.product as HouseModel);
  //   if (widget.product is CarModel)
  //     return _buildCarDetails(widget.product as CarModel);
  //   if (widget.product is JobVacancyModel)
  //     return _buildJobDetails(widget.product as JobVacancyModel);
  //   if (widget.product is LostOrFound)
  //     return _buildLOFDetails(widget.product as LostOrFound);
  //   if (widget.product is OtherItem)
  //     return _buildOtherItemDetails(widget.product as OtherItem);
  //   if (widget.product is AccessoryModel)
  //     return _buildAccessoryDetails(widget.product as AccessoryModel);
  //   if (widget.product is FashionModel)
  //     return _buildFashionDetails(widget.product as FashionModel);
  //   if (widget.product is ElectronicsModel)
  //     return _buildElectronicsDetails(widget.product as ElectronicsModel);
  //   if (widget.product is FreeStaffOrItem)
  //     return _buildFreeStuffDetails(widget.product as FreeStaffOrItem);

  //   return Text(
  //     'No specific details available',
  //     style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
  //   );
  // }
}

class PropertyBuilder {
  static dynamic createProperty(
      String selectedCategory, Map<String, dynamic> productData) {
    if (selectedCategory == "car") {
      return CarModel.from_dict(productData); // Expecting Map<String, dynamic>
    } else if (selectedCategory == "house") {
      return HouseModel.fromJson(productData); // Expecting Map<String, dynamic>
    } else {
      throw Exception("Invalid category");
    }
  }
}
