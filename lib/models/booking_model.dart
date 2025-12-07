import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String venueId;
  final DateTime date;
  final String userEmail;

  Booking({
    required this.id,
    required this.venueId,
    required this.date,
    required this.userEmail,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parsedDate;
    final dateValue = data['date'];
    if (dateValue is Timestamp) {
      parsedDate = dateValue.toDate();
    } else if (dateValue is String) {
      parsedDate = DateTime.parse(dateValue);
    } else {
      // Handle other cases or throw an error
      parsedDate = DateTime.now(); // Default value
    }

    return Booking(
      id: doc.id,
      venueId: data['venueId'] ?? '',
      date: parsedDate,
      userEmail: data['userEmail'] ?? '',
    );
  }
}
