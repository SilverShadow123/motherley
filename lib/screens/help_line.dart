import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: const Text(
          'Pregnancy Helpline',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildHelplineCard(
                    title: 'National Pregnancy Helpline',
                    description: '24/7 helpline for pregnancy-related support.',
                    phoneNumber: '+18001234567',
                  ),
                  buildHelplineCard(
                    title: 'Maternal Health Support',
                    description: 'Get information about maternal health.',
                    phoneNumber: '+18007654321',
                  ),
                  buildHelplineCard(
                    title: 'Nutrition Guidance',
                    description:
                    'Call this number to get nutritional information during pregnancy.',
                    phoneNumber: '+18009876543',
                  ),
                  buildHelplineCard(
                    title: 'Mental Health Support',
                    description:
                    'Contact a mental health expert for emotional well-being during pregnancy.',
                    phoneNumber: '+18005551234',
                  ),
                  buildHelplineCard(
                    title: 'Emergency Hotline',
                    description: 'Use this number for immediate assistance.',
                    phoneNumber: '911',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHelplineCard({
    required String title,
    required String description,
    required String phoneNumber,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(phoneNumber),
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spacer for some separation
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
