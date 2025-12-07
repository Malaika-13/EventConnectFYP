
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venue_model.dart';
import '../models/booking_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Venue>> getVenues() {
    return _db.collection('venues').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Venue(
              id: doc.id,
              name: data['name'] ?? '',
              description: data['description'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              category: data['category'] ?? '',
            );
          }).toList(),
        );
  }

  Future<Venue> getVenue(String venueId) async {
    final doc = await _db.collection('venues').doc(venueId).get();
    final data = doc.data();
    if (data == null) {
        throw Exception("Venue not found!");
    }
    return Venue(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        category: data['category'] ?? '',
    );
  }

  Stream<bool> isVenueBooked(String venueId, DateTime date) {
    return _db
        .collection('bookings')
        .where('venueId', isEqualTo: venueId)
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Future<void> bookVenue(String venueId, DateTime date, String userEmail) async {
    await _db.collection('bookings').add({
      'venueId': venueId,
      'date': Timestamp.fromDate(date),
      'userEmail': userEmail,
    });
  }

  Future<void> addVenue(Venue venue) async {
    await _db.collection('venues').add({
      'name': venue.name,
      'description': venue.description,
      'imageUrl': venue.imageUrl,
      'category': venue.category,
    });
  }

  Future<void> addVenues(List<Venue> venues) async {
    final batch = _db.batch();
    for (final venue in venues) {
      final docRef = _db.collection('venues').doc();
      batch.set(docRef, {
        'name': venue.name,
        'description': venue.description,
        'imageUrl': venue.imageUrl,
        'category': venue.category,
      });
    }
    await batch.commit();
  }

  Future<void> updateVenue(Venue venue) async {
    await _db.collection('venues').doc(venue.id).update({
      'name': venue.name,
      'description': venue.description,
      'imageUrl': venue.imageUrl,
      'category': venue.category,
    });
  }

  Future<void> deleteVenue(String venueId) async {
    await _db.collection('venues').doc(venueId).delete();
  }

  Stream<List<Booking>> getBookings() {
    return _db.collection('bookings').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            return Booking.fromFirestore(doc);
          }).toList(),
        );
  }

  Future<void> cancelBooking(String bookingId) async {
    await _db.collection('bookings').doc(bookingId).delete();
  }
}
