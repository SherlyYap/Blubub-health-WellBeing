import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/fitness/schedule.dart';
import 'package:project/global.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Plans',),
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0D273D),
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
            Text(
              title,
              style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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
              child:  Text(
                "Purchase",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    String title,
    double originalPrice,
  ) {
    bool discountApplied = false;
    String selectedPayment = 'Credit Card';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            double finalPrice =
                discountApplied ? originalPrice * 0.9 : originalPrice;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Confirm Subscription"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Plan: $title"),
                    subtitle: Text(
                      "Original Price: \$${originalPrice.toStringAsFixed(2)}",
                    ),
                    leading: const Icon(Icons.subscriptions, color: Color(0xff0D273D)),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedPayment,
                    decoration: const InputDecoration(
                      labelText: "Payment Method",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ["Credit Card", "PayPal", "Gopay", "OVO"]
                            .map(
                              (method) => DropdownMenuItem(
                                value: method,
                                child: Text(method),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedPayment = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: const Text("Apply 10% Discount"),
                    value: discountApplied,
                    onChanged: (value) {
                      setState(() {
                        discountApplied = value;
                      });
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
                  onPressed: () {
                    Future.delayed(Duration.zero, () async {
                      Schedule? schedule = await showScheduleDialog(context);

                      if (schedule != null) {
                        confirmedSchedule = schedule;
                        confirmedStartDate = schedule.startDate;

                        if (title == 'Weekly') {
                          confirmedEndDate = confirmedStartDate!.add(
                            const Duration(days: 6),
                          ); 
                        } else if (title == 'Monthly') {
                          confirmedEndDate = DateTime(
                            confirmedStartDate!.year,
                            confirmedStartDate!.month + 1,
                            confirmedStartDate!.day,
                          );
                        }

                        confirmedPlan = title;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "✅ Pembayaran berhasil dan jadwal telah dikonfirmasi!\n"
                              "Plan: $title\n"
                              "Latihan: ${schedule.workoutType}\n"
                              "Jadwal: ${schedule.days.join(', ')}\nWaktu: ${schedule.timeSlot}\nMulai: ${schedule.startDate.day}/${schedule.startDate.month}/${schedule.startDate.year}",
                            ),
                            backgroundColor: Colors.green[600],
                            duration: Duration(seconds: 4),
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 1));

                        Navigator.pop(context); 
                        Navigator.pop(context); 
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0D273D),
                  ),
                  child: const Text("Confirm", style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
