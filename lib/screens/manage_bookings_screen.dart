
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/booking_model.dart';
import '../services/firestore_service.dart';
import '../models/venue_model.dart';

class ManageBookingsScreen extends StatefulWidget {
  const ManageBookingsScreen({super.key});

  @override
  State<ManageBookingsScreen> createState() => ManageBookingsScreenState();
}

class ManageBookingsScreenState extends State<ManageBookingsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Sort by Date', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, color: Theme.of(context).colorScheme.secondary),
                tooltip: 'Toggle Sort Order',
                onPressed: () {
                  setState(() {
                    _sortAscending = !_sortAscending;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Booking>>(
            stream: _firestoreService.getBookings(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 18, color: Colors.red)));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerLoading();
              }
              final bookings = snapshot.data ?? [];
              if (bookings.isEmpty) {
                return const Center(
                  child: Text(
                    'No bookings found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              bookings.sort((a, b) {
                final dateA = a.date;
                final dateB = b.date;
                return _sortAscending
                    ? dateA.compareTo(dateB)
                    : dateB.compareTo(dateA);
              });

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return FutureBuilder<Venue>(
                    future: _firestoreService.getVenue(booking.venueId),
                    builder: (context, venueSnapshot) {
                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildBookingTile(context, booking, venueSnapshot),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const ListTile(
            leading: CircleAvatar(radius: 30, backgroundColor: Colors.white),
            title: SizedBox(height: 20, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white))),
            subtitle: SizedBox(height: 12, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingTile(
      BuildContext context, Booking booking, AsyncSnapshot<Venue> venueSnapshot) {
    Widget leadingWidget;
    String titleText;
    Widget? trailingWidget;

    if (venueSnapshot.connectionState == ConnectionState.done && venueSnapshot.hasData) {
      final venue = venueSnapshot.data!;
      titleText = venue.name;
      leadingWidget = Hero(
        tag: 'venueImage_${venue.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            venue.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.business, size: 40),
          ),
        ),
      );
      trailingWidget = IconButton(
        icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 30),
        tooltip: 'Cancel Booking',
        onPressed: () => _cancelBooking(context, booking),
      );
    } else if (venueSnapshot.hasError) {
      titleText = "Venue Not Found";
      leadingWidget =
          const CircleAvatar(radius: 30, child: Icon(Icons.error_outline));
      trailingWidget = const Icon(Icons.error, color: Colors.grey);
    } else {
      titleText = "Loading Venue...";
      leadingWidget = const CircleAvatar(
          radius: 30, child: CircularProgressIndicator(strokeWidth: 2));
      trailingWidget = const SizedBox.shrink();
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      leading: leadingWidget,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${booking.userEmail}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 5),
            Text(
              'Date: ${DateFormat.yMMMEd().format(booking.date.toLocal())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      trailing: trailingWidget,
      isThreeLine: true,
    );
  }

  Future<void> _cancelBooking(BuildContext context, Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text(
            'Are you sure you want to cancel this booking? This action is irreversible.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _firestoreService.cancelBooking(booking.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
