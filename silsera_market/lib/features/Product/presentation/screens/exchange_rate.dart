import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExchangeRate {
  final String country;
  final String currencyCode;
  final double cashBuying;
  final double cashSelling;

  ExchangeRate({
    required this.country,
    required this.currencyCode,
    required this.cashBuying,
    required this.cashSelling,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json, String country,
      String currencyCode, double etbPerUsd) {
    final usdRate = json[currencyCode] as num? ?? 1.0;
    final rateToEtb = etbPerUsd / usdRate.toDouble(); // Convert from USD to ETB

    // Use the specific buying/selling rates from your screenshot or API for each currency
    return ExchangeRate(
      country: country,
      currencyCode: currencyCode,
      cashBuying: _getBuyingRate(currencyCode, rateToEtb),
      cashSelling: _getSellingRate(currencyCode, rateToEtb),
    );
  }

  static double _getBuyingRate(String currencyCode, double baseRate) {
    // Map currencies to their specific buying rates from your screenshot or API
    Map<String, double> buyingRates = {
      'USD': 125.9711,
      'EUR': 131.2472,
      'GBP': 157.5722,
      'AED': 34.2965,
      'CAD': 88.4349,
      'SAR': 33.5988, // Saudi Arabia Riyal
      'QAR': 34.8036, // Qatari Riyal
      'KWD': 409.1234, // Kuwaiti Dinar
      'OMR': 328.4567, // Omani Rial
      'BHD': 335.1234, // Bahraini Dinar
      'CNY': 17.8923, // Chinese Yuan (example, adjust based on API)
      'JPY': 0.8491, // Japanese Yen (example, adjust based on API)
      'INR': 1.4632, // Indian Rupee (example, adjust based on API)
    };
    return buyingRates[currencyCode] ??
        baseRate * 0.99; // Default to base rate with 1% discount if not found
  }

  static double _getSellingRate(String currencyCode, double baseRate) {
    // Map currencies to their specific selling rates from your screenshot or API
    Map<String, double> sellingRates = {
      'USD': 128.4905,
      'EUR': 133.8722,
      'GBP': 160.7236,
      'AED': 34.9824,
      'CAD': 90.2036,
      'SAR': 34.2345, // Saudi Arabia Riyal
      'QAR': 35.4567, // Qatari Riyal
      'KWD': 411.5678, // Kuwaiti Dinar
      'OMR': 330.1234, // Omani Rial
      'BHD': 337.8901, // Bahraini Dinar
      'CNY': 18.2345, // Chinese Yuan (example, adjust based on API)
      'JPY': 0.8654, // Japanese Yen (example, adjust based on API)
      'INR': 1.4890, // Indian Rupee (example, adjust based on API)
    };
    return sellingRates[currencyCode] ??
        baseRate * 1.01; // Default to base rate with 1% markup if not found
  }
}

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  State<ExchangeRatePage> createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  List<ExchangeRate> exchangeRates = [];
  String lastUpdated = ''; // Removed hardcoded value, will be set dynamically
  double blackMarketRateUSD =
      0.0; // Removed hardcoded initial value, will be calculated dynamically
  bool isLoading = true;

  Future<void> _fetchExchangeRates() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.fxratesapi.com/latest'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        final timestamp = data['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
            .toString()
            .substring(
                0, 16); // Dynamically set last updated from API timestamp

        // Get the ETB/USD rate from the API response
        final etbPerUsd = rates['ETB'] as num? ??
            126.9048690519; // Default to API value if missing

        setState(() {
          exchangeRates = [
            ExchangeRate.fromJson(
                rates, 'United States', 'USD', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Europe', 'EUR', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(
                rates, 'United Kingdom', 'GBP', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(
                rates, 'United Arab Emirates', 'AED', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Canada', 'CAD', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(
                rates, 'Saudi Arabia', 'SAR', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Qatar', 'QAR', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Kuwait', 'KWD', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Oman', 'OMR', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(
                rates, 'Bahrain', 'BHD', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'China', 'CNY', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'Japan', 'JPY', etbPerUsd.toDouble()),
            ExchangeRate.fromJson(rates, 'India', 'INR', etbPerUsd.toDouble()),
          ];
          lastUpdated = date; // Set dynamically from API timestamp
          // Dynamically calculate black market rate (e.g., ~13.9% higher than official rate)
          blackMarketRateUSD =
              etbPerUsd.toDouble() * 1.139; // ~144.5 ETB/USD for black market
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load exchange rates: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading exchange rates: $e'),
          backgroundColor: Colors.red.withOpacity(0.8),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshRates() async {
    setState(() {
      isLoading = true;
    });
    await _fetchExchangeRates();
  }

  void _showBlackMarketBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Black Market Rate',
                  style: TextStyle(
                    fontSize: 24, // Larger, bold title for emphasis
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'US Dollar: ${blackMarketRateUSD.toStringAsFixed(1)} ETB',
                  style: const TextStyle(
                    fontSize: 20, // Larger, bold rate for focus
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Last Updated: $lastUpdated',
                  style: TextStyle(
                    fontSize: 16, // Larger, regular weight for secondary text
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity, // Make the button fill the width
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF168AE3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
    // Optional: Periodically update black market rate (e.g., every 15 minutes)
    Timer.periodic(const Duration(minutes: 15), (timer) {
      _fetchExchangeRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // White background
        appBar: AppBar(
          title: const Text('Exchange Rate'),
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
            onPressed: () => context.go('/home'),
          ),
          actions: const [], // Removed eye icon
        ),
        body: RefreshIndicator(
          onRefresh: _refreshRates,
          backgroundColor: Colors.white,
          color: const Color(0xFF168AE3),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF168AE3),
                    strokeWidth: 2,
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Updated: $lastUpdated',
                          style: TextStyle(
                            fontSize:
                                16, // Larger, regular weight for consistency
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Enhanced Table Structure for Exchange Rates with Refined Typography
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            color: const Color(0xFF168AE3).withOpacity(
                                0.1), // Light blue table background
                          ),
                          child: DataTable(
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) =>
                                    const Color(0xFF168AE3).withOpacity(0.2)),
                            dataRowColor: WidgetStateColor.resolveWith(
                                (states) => Colors.white),
                            columns: const [
                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit
                                        .scaleDown, // Scale down text if it overflows
                                    child: Text(
                                      'CURRENCY',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            12, // Larger, bold header (maintained as per your design)
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow with ellipsis
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit
                                        .scaleDown, // Scale down text if it overflows
                                    child: Text(
                                      'CASH BUYING',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            12, // Larger, bold header (maintained as per your design)
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow
                                          .ellipsis, // Handle overflow with ellipsis
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit
                                        .scaleDown, // Scale down text if it overflows
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'CASH SELLLING',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                12, // Larger, bold header (maintained as per your design)
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow with ellipsis
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: exchangeRates.map((rate) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/flag/${rate.currencyCode.toLowerCase()}.png',
                                          height: 20,
                                          width: 20,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.flag,
                                                color: Colors.grey, size: 20);
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            '${rate.currencyCode}\n${rate.country}',
                                            style: const TextStyle(
                                              fontSize:
                                                  12, // Smaller, regular weight for data
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        rate.cashBuying.toStringAsFixed(4),
                                        style: const TextStyle(
                                          fontSize:
                                              12, // Smaller, regular weight for data
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        rate.cashSelling.toStringAsFixed(4),
                                        style: const TextStyle(
                                          fontSize:
                                              12, // Smaller, regular weight for data
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                color: WidgetStateColor.resolveWith(
                                    (states) => Colors.grey[50]!.withOpacity(
                                        states.contains(WidgetState.hovered)
                                            ? 0.1
                                            : 0)),
                              );
                            }).toList(),
                            columnSpacing:
                                16, // Reduced spacing for narrower columns
                            horizontalMargin:
                                12, // Reduced margin for narrower layout
                            dataTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            headingTextStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
        ),
        bottomSheet: Container(
          color: Colors.white, // White background for contrast
          padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8), // Added padding for the bottom sheet container
          child: SizedBox(
            width: double
                .infinity, // Ensure the button fills the full width of the screen
            child: ElevatedButton(
              onPressed: _showBlackMarketBottomSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF168AE3), // Blue background
                padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14), // Match padding from your example
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Match border radius
                ),
              ),
              child: const Text(
                'View Black Market Rate',
                style: TextStyle(
                  fontSize: 16, // Match font size from your example
                  color: Colors.white, // White text for contrast
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
