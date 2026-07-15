import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silesra/features/Product/presentation/widgets/custom_bottom_navigation.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final int _currentIndex = 2;

  final List<Map<String, String>> transactions = [
    {
      "property": "Luxury Villa in Mexico",
      "price": "\$500,000",
      "date": "Jan 20, 2024",
    },
    {
      "property": "Commercial Building in Asko",
      "price": "\$750,000",
      "date": "Feb 5, 2024",
    },
    {
      "property": "Condo in Jemo",
      "price": "\$320,000",
      "date": "Mar 10, 2024",
    },
    {
      "property": "Villa in Semmit",
      "price": "\$600,000",
      "date": "Apr 18, 2024",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(248, 252, 255, 1),
                border: Border.all(
                  color: const Color.fromRGBO(21, 138, 226, 1),
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(22, 138, 227, 0.16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.home_filled,
                      color: Color.fromRGBO(21, 138, 226, 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction["property"]!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction["price"]!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction["date"]!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      
    );
  }
}
