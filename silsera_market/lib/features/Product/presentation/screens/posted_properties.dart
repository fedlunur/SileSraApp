import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Added for icons
import 'package:silesra/core/config/MiscillaniousModels.dart';
import 'package:silesra/core/config/settings.dart';
import 'package:silesra/core/config/user_auth_data.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/POST/BaseService.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Posted_Items/posted_itemmodel.dart';
import 'package:silesra/features/Product/data/models/product_model.dart';

class PostedPropertyPage extends StatefulWidget {
  const PostedPropertyPage({super.key});

  @override
  _PostedPropertyPageState createState() => _PostedPropertyPageState();
}

class _PostedPropertyPageState extends State<PostedPropertyPage> {
  final int _currentIndex = 1; // Assuming the Posted Property Page index is 1
  var postedProperties = [];
  User? _user;
  List<Category> catagories = [];
  @override
  void initState() {
    super.initState();
    _loadUser();
    loadCatagories();
  }

  Future<void> loadCatagories() async {
    try {
      List<Category> catag = await ApiService.fetchCategories();
      print("%%% Error loading Catagories ");
      setState(() {
        catagories = catag;
      });
    } catch (e) {
      print("Error loading car types: $e");
    }
  }

  bool isloading = true;

  Future<void> _loadUser() async {
    User? user = await SharedPreferenceHelper.getUser();
    setState(() {
      _user = user;
    });
    _fetchListings(_user!.phone ?? '096832');
  }

  String timeAgo(DateTime createdAt) {
    DateTime createdTime = createdAt.toLocal();
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} minutes ago Name: ";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} hours ago";
    } else {
      return DateFormat('MMM d, yyyy').format(createdTime);
    }
  }

  Future<void> _fetchListings(String phone) async {
    final listingProvider =
        Provider.of<ListingProvider>(context, listen: false);
    try {
      List<PostedItem> postedItems =
          await listingProvider.postedItemService.fetchPostedItems();
          
      setState(() {
        postedProperties = postedItems;
        isloading = false;
      });
      print("%%%% These are the posted items: $postedProperties");
    } catch (e) {
      print("Error fetching posted items: $e");
      setState(() {
        isloading = false;
      });
    }
  }

  void _handleTap(String api, int id) async {
    setState(() {
      isloading = true; // Show loader when tapped
    });

    await _gottoDetailPage(api, id);

    setState(() {
      isloading = false; // Hide loader after navigation
    });
  }

  final BaseService service = BaseService("watchlist");
  Future<void> _gottoDetailPage(String modelname, int itemid) async {
    try {
      print("   ======>   Go to Detail page ");
      BaseListing product = await service.getSingleModelData(itemid, modelname);
      print("   ======>  after  Go to Detail page ");
      // Navigate to the detail page with the product
      GoRouter.of(context).push('/detail', extra: {'product': product});
    } catch (e) {
      // Handle any errors that occur during the process
      print("Error navigating to detail page: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF), // Light off-white background
      appBar: AppBar(
        title: const Text('Posted Items'),
        centerTitle: true, // Centered title for modern look
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
          onPressed: () => context.go('/profile'),
        ),
        actions: const [], // Removed eye icon
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : postedProperties.isEmpty
              ? Center(
                  child: Text(
                    "No items found.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  itemCount: postedProperties.length,
                  itemBuilder: (context, index) {
                    final item = postedProperties[index];
                    return InkWell(
                      onTap: isloading
                          ? null
                          : () {
                              _handleTap(item.category['api'], item.id);
                            },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        color: Colors.white,
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
                                    color: parseColor(item.category['color'] ??
                                        "rgba(76, 175, 80, 0.2)"),
                                    border: Border.all(
                                      color: const Color.fromRGBO(21, 138, 226, 1),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                      getCategoryIcon(item.category['icon'] ??
                                          'more_horiz'),
                                      size: 30,
                                      color: const Color.fromRGBO(21, 138, 226, 1)
                                      // Keep the icon color white for contrast
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
                                        text: 'Posted: ',
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
                                Text(
                                  'Status: ${item.approval_status}',
                                  style: GoogleFonts.poppins(
                                    color: item.approval_status == 'Approved'
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  // Placeholder for delete logic
                                  print(
                                      "Delete selected for item: ${item.name}");
                                } else if (value == 'edit') {
                                  _gottoDetailPage(
                                      item.category['api'], item.itemId);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.pen,
                                          size: 16,
                                          color: Color(0xFF168AE3)),
                                      const SizedBox(width: 8),
                                      Text('Edit',
                                          style: GoogleFonts.poppins(
                                              color: const Color(0xFF168AE3))),
                                    ],
                                  ),
                                ),
                              ],
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
