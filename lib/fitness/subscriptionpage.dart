import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/fitness/schedule.dart';
import 'package:project/global.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionSuccessPage extends StatelessWidget {
  final String plan;
  final double price;
  final String paymentMethod;

  const SubscriptionSuccessPage({
    super.key,
    required this.plan,
    required this.price,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              Text(
                "Subscription Successful!",
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Plan: $plan\nPayment: $paymentMethod\nPrice: \$${price.toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0D273D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Back to Plans",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionInfoPage extends StatefulWidget {
  final String? plan;
  final double? price;
  final String? paymentMethod;
  final String? startDate;
  final String? endDate;

  const SubscriptionInfoPage({
    super.key,
    this.plan,
    this.price,
    this.paymentMethod,
    this.startDate,
    this.endDate,
  });

  @override
  State<SubscriptionInfoPage> createState() => _SubscriptionInfoPageState();
}

class _SubscriptionInfoPageState extends State<SubscriptionInfoPage> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logEvent(
      name: 'subscription_info_viewed',
      parameters: {'screen_name': 'SubscriptionInfoPage'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    DateTime? start =
        widget.startDate != null ? DateTime.tryParse(widget.startDate!) : null;
    DateTime? end =
        widget.endDate != null ? DateTime.tryParse(widget.endDate!) : null;

    String startFormatted = start != null ? formatter.format(start) : '-';
    String endFormatted = end != null ? formatter.format(end) : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Plans'),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff0D273D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPlanCard(
              context,
              title: "Weekly",
              price: "\$200",
              priceValue: 200,
              features: [
                "Private training sessions online",
                "Unlimited access to all features",
                "Gym & fitness classes",
              ],
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              title: "Monthly",
              price: "\$600",
              priceValue: 600,
              features: [
                "Private training sessions online",
                "Access to gym & fitness center",
                "Unlimited access to all features",
                "Coaching 1 on 1 session",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required double priceValue,
    required List<String> features,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(price, style: GoogleFonts.nunito(fontSize: 16)),
            const Divider(height: 20, thickness: 1),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showPaymentDialog(context, title, priceValue),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0D273D),
                minimumSize: const Size.fromHeight(40),
              ),
              child: Text("Purchase",
                  style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(
      BuildContext context, String title, double originalPrice) {
    bool discountApplied = false;
    String selectedPayment = 'Credit Card';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (ctx, setState) {
          double finalPrice =
              discountApplied ? originalPrice * 0.9 : originalPrice;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Confirm Subscription"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Plan: $title"),
                  subtitle:
                      Text("Original Price: \$${originalPrice.toStringAsFixed(2)}"),
                  leading: const Icon(Icons.subscriptions,
                      color: Color(0xff0D273D)),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPayment,
                  decoration: const InputDecoration(
                    labelText: "Payment Method",
                    border: OutlineInputBorder(),
                  ),
                  items: ["Credit Card", "PayPal", "Gopay", "OVO"]
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedPayment = value);
                    }
                  },
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text("Apply 10% Discount"),
                  value: discountApplied,
                  onChanged: (value) {
                    setState(() => discountApplied = value);
                  },
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 10),
                Text(
                  "Final Price: \$${finalPrice.toStringAsFixed(2)}",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: discountApplied ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Schedule? schedule = await showScheduleDialog(context);

                  if (schedule != null && context.mounted) {
                    confirmedSchedule = schedule;
                    confirmedStartDate = schedule.startDate;

                    if (title == 'Weekly') {
                      confirmedEndDate =
                          confirmedStartDate!.add(const Duration(days: 6));
                    } else if (title == 'Monthly') {
                      confirmedEndDate = DateTime(
                        confirmedStartDate!.year,
                        confirmedStartDate!.month + 1,
                        confirmedStartDate!.day,
                      );
                    }

                    confirmedPlan = title;
                    await FirebaseAnalytics.instance.logPurchase(
                      currency: 'USD',
                      value: finalPrice,
                      transactionId:
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      items: [
                        AnalyticsEventItem(
                          itemId: title,
                          itemName: '$title Subscription',
                          price: finalPrice,
                          quantity: 1,
                        ),
                      ],
                    );

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('plan', title);
                    await prefs.setDouble('price', finalPrice);
                    await prefs.setString('paymentMethod', selectedPayment);
                    await prefs.setString(
                        'startDate', confirmedStartDate.toString());
                    await prefs.setString(
                        'endDate', confirmedEndDate.toString());

                    Navigator.pop(context); 
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Pembayaran berhasil!\nPlan: $title\n"
                          "Latihan: ${schedule.workoutType}\n"
                          "Jadwal: ${schedule.days.join(', ')}\n"
                          "Mulai: ${schedule.startDate.day}/${schedule.startDate.month}/${schedule.startDate.year}",
                        ),
                        backgroundColor: Colors.green[600],
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    if (ctx.mounted) {
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => SubscriptionSuccessPage(
                            plan: title,
                            price: finalPrice,
                            paymentMethod: selectedPayment,
                          ),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0D273D)),
                child:
                    const Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }
}
