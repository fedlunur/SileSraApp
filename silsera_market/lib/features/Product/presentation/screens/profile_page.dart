import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:silesra/features/Auth/models/user_model.dart';
import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_event.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';
import 'package:silesra/features/News/Block/block.dart';
import 'package:silesra/features/News/Block/event.dart';
import 'package:silesra/features/News/Block/state.dart';
import 'package:silesra/features/POST/ListingProvider.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_bottom_navigation.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_floating_action_button.dart';
import 'package:silesra/core/config/user_auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String avatarUrl = 'assets/avatar2.png';
  File? profileImage;

  final ImagePicker picker = ImagePicker();
  int _currentIndex = 3; // Profile is the third tab

  final bool _isLoading = false;
  final String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        profileImage = File(imagePath);
      });
    }
  }

  /// Pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    File pickedImage = File(pickedFile.path);
    await _saveProfileImage(pickedImage);
  }

  /// Save image to local storage and store path in SharedPreferences
  Future<void> _saveProfileImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile.jpg';

    await imageFile.copy(imagePath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', imagePath);

    setState(() {
      profileImage = File(imagePath);
      avatarUrl = ""; // Reset URL if new image is picked
    });
  }

  final userService = ListingProvider();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isloading = false;

  Future<void> logout(BuildContext context) async {
    await SharedPreferenceHelper
        .clearUser(); // Clear user data from SharedPreferences
    context.go('/sign_in');
    // Navigate to the login screen or any other appropriate screen
  }

  void _showAboutUsPopup() {
    // Create a ScrollController
    final ScrollController scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // About Us Section with Scrollable Paragraph and Opaque Scrollbar
              Container(
                padding: const EdgeInsets.all(16.0),
                constraints: const BoxConstraints(
                    maxHeight: 200), // Limit height for scrollability
                child: Scrollbar(
                  controller: scrollController, // Assign the ScrollController
                  thumbVisibility: true, // Show scrollbar thumb always
                  thickness: 6, // Thickness of the scrollbar
                  radius: const Radius.circular(
                      8), // Rounded corners for a modern look
                  scrollbarOrientation:
                      ScrollbarOrientation.right, // Scrollbar on the right
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(
                        const Color(0xFF168AE3)
                            .withOpacity(0.3), // Light blue with 30% opacity
                      ),
                      trackColor: WidgetStateProperty.all(
                        Colors.grey.withOpacity(0.1), // Very light grey track
                      ),
                      trackBorderColor: WidgetStateProperty.all(
                        Colors.transparent, // No border for a clean look
                      ),
                      radius: const Radius.circular(8), // Match thumb radius
                      thickness:
                          WidgetStateProperty.all(6), // Match thumb thickness
                    ),
                    child: SingleChildScrollView(
                      controller:
                          scrollController, // Assign the same ScrollController
                      padding: EdgeInsets.zero, // No additional padding
                      child: const Text(
                        "Welcome to Silsera Market, your trusted online marketplace for a diverse range of items. We connect buyers and sellers seamlessly, offering a user-friendly platform to explore listings, negotiate deals, and manage transactions securely. Our mission is to simplify the process of finding what you need, whether you're looking for vehicles, houses, fashion, electronics, accessories, or job vacancies, all while ensuring a transparent and efficient experience for our community.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5, // Line height for better readability
                        ),
                        textAlign: TextAlign.justify, // Justified text
                      ),
                    ),
                  ),
                ),
              ),
              // Styled Divider
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Divider(
                  thickness: 2, // Thicker divider for emphasis
                  color: const Color(0xFF168AE3).withOpacity(0.5), // Light blue
                  indent: 20, // Indent from left
                  endIndent: 20, // Indent from right
                ),
              ),
              // Attractive Social Media Icons Arrangement in a Single Line
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center-align icons
                  mainAxisSize: MainAxisSize.min, // Minimize row’s width
                  children: [
                    Flexible(
                      child: _buildSocialIcon(FontAwesomeIcons.facebook,
                          Colors.blue, 'https://facebook.com/silseramarket'),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: _buildSocialIcon(FontAwesomeIcons.telegram,
                          Colors.blue, 'https://t.me/silseramarket'),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: _buildSocialIcon(FontAwesomeIcons.tiktok,
                          Colors.black, 'https://tiktok.com/@silseramarket'),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: _buildSocialIcon(FontAwesomeIcons.youtube,
                          Colors.red, 'https://youtube.com/@silseramarket'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF168AE3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Dispose of the controller when the dialog is closed (optional, good practice)
    scrollController.dispose();
  }

// Helper method to build styled social media icons
  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return MouseRegion(
      onEnter: (_) {}, // Add hover effect for web (optional)
      onExit: (_) {},
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          width: 40, // Reduced width for better fit
          height: 40, // Reduced height for better fit
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular background for modern look
            color: Colors.white, // White background for contrast
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2), // Subtle shadow for elevation
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 18, // Reduced size for better fit within smaller circle
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserBloc bloc) =>
        bloc.state is UserLoaded ? (bloc.state as UserLoaded).user : null);

    // Trigger checking premium status after user is available
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<PromotionsPlansNewsBloc>()
            .add(CheckPremiumStatusEvent(user.id!));
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: _buildAppBar(context, user),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) => _handleUserState(context, state),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            _buildProfileCard(user),
            const SizedBox(height: 20),
            _buildAccountOptionsList(context, user),
            const SizedBox(height: 10),
            const Text("💡 Your Premium Account Status!"),
            const SizedBox(height: 10),
            BlocBuilder<PromotionsPlansNewsBloc, PromotionsPlansNewsState>(
              builder: (context, state) => _buildPremiumStatus(state),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onBottomNavTap(context, index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, User? user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          context.go('/home');
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.link,
              color: Color(0xFF168AE3), size: 24),
          onPressed: _showAboutUsPopup,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          onSelected: (String value) async {
            if (value == 'Login') {
              context.go('/sign_in');
            } else if (value == 'Signup') {
              context.go('/sign_up');
            } else if (value == 'Logout') {
              await logout(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              if (user?.id == null)
                const PopupMenuItem<String>(
                  value: 'Login',
                  child: Row(
                    children: [
                      Icon(Icons.app_registration, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Login', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                )
              else
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  void _handleUserState(BuildContext context, UserState state) {
    if (state is UserLoggedOut) {
      Navigator.of(context).pop();
      context.go('/sign_in');
    } else if (state is UserError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildProfileCard(User? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 75.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl) as ImageProvider
                        : const AssetImage('assets/avatar2.png'),
              ),
              const SizedBox(height: 10),
              Text(
                user?.firstName ?? 'Guest',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user?.phone ?? 'No phone number',
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: changeProfilePicture,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text("Change profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Color(0xFF168AE3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOptionsList(BuildContext context, User? user) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildAccountOption(
            Icons.star, "Watchlist", () => context.push('/wishlist')),
        if (user != null)
          _buildAccountOption(
              Icons.lock, "Change Password", () => changePassword(context)),
        _buildAccountOption(
            Icons.house, "My Posts", () => context.push('/postedproperties')),
        _buildAccountOption(Icons.person, "Premium User Request",
            () => context.push('/premium')),
      ],
    );
  }

  Widget _buildPremiumStatus(PromotionsPlansNewsState state) {
    if (state is PremiumStatusLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PremiumStatusLoaded) {
      final premiumStatus = state.premiumStatus;
      print(" %%%%  The Preium status in the widget is ${premiumStatus}");
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: premiumStatus.status == 'no_active_plan'
            ? Card(
                child: _buildPremiumRow(
                  Icons.post_add_rounded,
                  Colors.green,
                  'No Premium Request Yet ',
                  '',
                ),
              )
            : Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildPremiumRow(Icons.post_add_rounded, Colors.green,
                          'Total Allowed Posts', premiumStatus.allowedPosts),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(Icons.library_books, Colors.blueAccent,
                          'Current Posts', premiumStatus.currentPosts),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(
                          Icons.pending,
                          Colors.orange,
                          'Remaining Posts',
                          premiumStatus.allowedPosts -
                              premiumStatus.currentPosts),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(Icons.attach_money, Colors.teal,
                          'Total Amount', premiumStatus.totalAmount),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(Icons.money_off, Colors.redAccent,
                          'Used Amount', premiumStatus.usedAmount),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(
                          Icons.account_balance_wallet,
                          Colors.blueAccent,
                          'Remaining Balance',
                          premiumStatus.remainingBalance),
                      const Divider(height: 20, thickness: 1),
                      _buildPremiumRow(Icons.access_time_filled, Colors.orange,
                          'Expire Date', premiumStatus.expire_date),
                      const Divider(height: 20, thickness: 1),
                      // _buildPremiumRow(Icons.info, Colors.deepPurple, 'Message',
                      //     premiumStatus.message),
                    ],
                  ),
                ),
              ),
      );
    } else if (state is PremiumStatusError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error loading premium status: ${state.message}',
            style: const TextStyle(color: Colors.red)),
      );
    }
    return const SizedBox(); // no data yet
  }

  Widget _buildPremiumRow(
      IconData icon, Color iconColor, String title, dynamic value) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$title: $value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _onBottomNavTap(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
    });
    final routes = ['/home', '/wishlist', '/messages', '/profile', '/chat'];
    context.go(routes[index]);
  }

  // Change Profile Picture Logic
  Future<void> changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Account Option Widget
  Widget _buildAccountOption(IconData icon, String title, Function() onTap) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF168AE3)),
        title: Text(title,
            style: const TextStyle(fontSize: 16, color: Colors.black)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Change Password Logic
  void changePassword(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user; // Get the current user
      String? pwd = user.password;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF8FCFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Change Password $pwd',
              style: const TextStyle(
                color: Color(0xFF168AE3),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: const TextStyle(color: Color(0xFF168AE3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF168AE3)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: const TextStyle(color: Color(0xFF168AE3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF168AE3)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: const TextStyle(color: Color(0xFF168AE3)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF168AE3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF168AE3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (currentPasswordController.text.isEmpty ||
                      newPasswordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All fields are required.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New passwords do not match '),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  context.read<UserBloc>().add(
                        ChangePassword(
                          oldpassword: currentPasswordController.text,
                          newpassword: newPasswordController.text,
                          confrimpassword: confirmPasswordController.text,
                          curuser: user,
                        ),
                      );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _PopupMenuItemContent extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PopupMenuItemContent({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: icon == Icons.logout ? Colors.red : Colors.green),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
