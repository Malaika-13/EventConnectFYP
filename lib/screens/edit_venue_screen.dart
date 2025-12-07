import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/firestore_service.dart';

class EditVenueScreen extends StatefulWidget {
  final Venue venue;

  const EditVenueScreen({super.key, required this.venue});

  @override
  State<EditVenueScreen> createState() => _EditVenueScreenState();
}

class _EditVenueScreenState extends State<EditVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  late String _name;
  late String _description;
  late String _imageUrl;
  late String _category;

  @override
  void initState() {
    super.initState();
    _name = widget.venue.name;
    _description = widget.venue.description;
    _imageUrl = widget.venue.imageUrl;
    _category = widget.venue.category;
  }

  void _updateVenue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedVenue = Venue(
        id: widget.venue.id,
        name: _name,
        description: _description,
        imageUrl: _imageUrl,
        category: _category,
      );
      _firestoreService.updateVenue(updatedVenue).then((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venue updated successfully!')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Venue'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                    onSaved: (value) => _name = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _imageUrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an image URL' : null,
                    onSaved: (value) => _imageUrl = value!,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['Resort', 'Corporate Hall', 'Banquet', 'Marquee']
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateVenue,
                    child: const Text('Update Venue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
