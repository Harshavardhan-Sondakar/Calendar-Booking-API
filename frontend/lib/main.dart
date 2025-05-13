import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CalendarBookingApp());
}

class CalendarBookingApp extends StatelessWidget {
  const CalendarBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting Room Bookings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookingListScreen(),
    );
  }
}

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/bookings'));
      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bookings')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> createBooking(String userId, String start, String end) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'startTime': start,
          'endTime': end,
        }),
      );
      if (response.statusCode == 201) {
        fetchBookings();
        Navigator.pop(context); // Close dialog on success
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateBooking(String id, String userId, String start, String end) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/bookings/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'startTime': start,
          'endTime': end,
        }),
      );
      if (response.statusCode == 200) {
        fetchBookings();
        Navigator.pop(context); // Close dialog on success
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> deleteBooking(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/bookings/$id'),
      );
      if (response.statusCode == 200) {
        fetchBookings();
      } else {
        final error = json.decode(response.body)['error'] ?? 'Error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void showBookingDialog({Map? editBooking}) {
    final userIdController = TextEditingController(text: editBooking?['userId'] ?? '');
    final startController = TextEditingController(text: editBooking?['startTime'] ?? '');
    final endController = TextEditingController(text: editBooking?['endTime'] ?? '');

    Future<void> pickDateTime(TextEditingController controller, {String? label}) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        helpText: label,
      );
      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final dt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          controller.text = dt.toUtc().toIso8601String();
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(editBooking == null ? 'New Booking' : 'Edit Booking'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: startController,
                readOnly: true,
                onTap: () => pickDateTime(startController, label: 'Pick Start Time'),
                decoration: const InputDecoration(
                  labelText: 'Start Time (UTC)',
                  hintText: '2025-03-01T10:00:00Z',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endController,
                readOnly: true,
                onTap: () => pickDateTime(endController, label: 'Pick End Time'),
                decoration: const InputDecoration(
                  labelText: 'End Time (UTC)',
                  hintText: '2025-03-01T11:00:00Z',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (editBooking == null) {
                createBooking(
                  userIdController.text.trim(),
                  startController.text.trim(),
                  endController.text.trim(),
                );
              } else {
                updateBooking(
                  editBooking['id'],
                  userIdController.text.trim(),
                  startController.text.trim(),
                  endController.text.trim(),
                );
              }
            },
            child: Text(editBooking == null ? 'Book' : 'Update'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Room Bookings'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBookings,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text('No bookings found.'))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final b = bookings[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.meeting_room, color: Colors.blue.shade700),
                        ),
                        title: Text(
                          'User: ${b['userId']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Start: ${b['startTime']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            Text(
                              'End:   ${b['endTime']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showBookingDialog(editBooking: b),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteBooking(b['id']),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showBookingDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Booking'),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}