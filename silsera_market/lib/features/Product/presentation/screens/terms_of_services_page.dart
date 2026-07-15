import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  late ScrollController _scrollController;
  late String lastUpdated;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    lastUpdated =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FCFF),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo2.svg', // Change to your SVG file
                  height: 34,
                  width: 34,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AGREEMENT",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        "Terms of Service",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        " Agreement date $lastUpdated",
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Scrollbar(
          controller: _scrollController,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              setState(() {});
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Add the Welcome message here
                  const Text(
                    "Welcome to our Terms of Service",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "By using this application, you agree to abide by the following terms and conditions:",
                    style: TextStyle(
                        fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Sections
                  _buildSection("Prohibited Content"),
                  _buildBulletPoint(
                      "• Food, beverage, and medicine not allowed"),
                  _buildBulletPoint("• Tobacco and alcohol not allowed"),
                  _buildBulletPoint("• Internet pictures not allowed"),
                  _buildBulletPoint("• Undecided price inputs not allowed"),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 20),

                  _buildSection("Posting Approval"),
                  _buildBulletPoint(
                      "• Wait at least 20 minutes for verification"),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 20),

                  _buildWarningBox(
                      "⚠️ Failure to comply may result in account suspension."),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Color(0xFF168AE3)),
                    ),
                    child: const Text(
                      "Decline",
                      style: TextStyle(fontSize: 16, color: Color(0xFF168AE3)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/city_selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF168AE3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Accept & Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3),
      ),
    );
  }

  Widget _buildWarningBox(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }
}
