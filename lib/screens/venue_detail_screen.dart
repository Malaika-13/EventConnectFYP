import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/venue_model.dart';
import '../services/firestore_service.dart';
import 'package:google_fonts/google_fonts.dart';

class VenueDetailScreen extends StatefulWidget {
  final Venue venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  State<VenueDetailScreen> createState() => VenueDetailScreenState();
}

class VenueDetailScreenState extends State<VenueDetailScreen> {
  DateTime? _selectedDate;
  final _firestoreService = FirestoreService();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _bookVenue() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date.')));
      return;
    }
    final userEmail = FirebaseAuth.instance.currentUser!.email!;
    _firestoreService
        .bookVenue(widget.venue.id, _selectedDate!, userEmail)
        .then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue booked successfully!')),
      );
      _launchWhatsApp(userEmail);
    });
  }

  void _launchWhatsApp(String userEmail) async {
    const phoneNumber =
        '+9203259220543'; // Replace with your WhatsApp number
    final message =
        'Hello, I have booked ${widget.venue.name} for ${_selectedDate!.toLocal()}. My email is $userEmail.';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch WhatsApp. Please make sure it is installed.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching WhatsApp: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.venue.name)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.venue.id,
                    child: Image.network(
                      widget.venue.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.venue.name,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.venue.category,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.venue.description,
                          style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Booking Date',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                _selectedDate == null
                                    ? 'Choose Date'
                                    : '${_selectedDate!.toLocal()} '.split(
                                        ' ',
                                      )[0],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_selectedDate != null)
                          Center(
                            child: StreamBuilder<bool>(
                              stream: _firestoreService.isVenueBooked(
                                widget.venue.id,
                                _selectedDate!,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                final isBooked = snapshot.data ?? false;
                                return Text(
                                  isBooked ? 'Reserved' : 'Available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isBooked ? Colors.red : Colors.green,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<bool>(
                stream: _firestoreService.isVenueBooked(
                  widget.venue.id,
                  _selectedDate!,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final isBooked = snapshot.data ?? false;
                  return isBooked
                      ? Text(
                          'This date is unavailable. Please select another date.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _bookVenue,
                          child: const Text('Book Now'),
                        );
                },
              ),
            ),
        ],
      ),
    );
  }
}
