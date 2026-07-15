import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "You've posted your first ad for free.\n"
              "Feel free to post additional ads for a small payment.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              "Additional Ad Price",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF168AE3),
              ),
            ),
            const SizedBox(height: 10),
            _buildAdPriceItem("Houses", "15 Br / ad"),
            _buildAdPriceItem("Cars", "14 Br / ad"),
            _buildAdPriceItem("Other items", "5 Br / ad"),
            _buildAdPriceItem("Service ads", "4 Br / ad"),
            _buildAdPriceItem("Wanted ads", "4 Br / ad"),
            _buildAdPriceItem("Job ads", "150 Br / ad"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF168AE3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "PAY NOW",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
      
      
    );
  }

  Widget _buildAdPriceItem(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
