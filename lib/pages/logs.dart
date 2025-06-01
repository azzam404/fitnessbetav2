import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final CollectionReference _logsCollection =
  FirebaseFirestore.instance.collection('food_logs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        title: const Text('Food Logs', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _logsCollection.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No logs yet.',
                    style: TextStyle(color: Colors.white)));
          }

          final logs = snapshot.data!.docs;

          // Group logs by date
          Map<String, List<QueryDocumentSnapshot>> groupedLogs = {};
          for (var log in logs) {
            final data = log.data() as Map<String, dynamic>;
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final dateKey = DateFormat('yyyy-MM-dd').format(timestamp);

            if (!groupedLogs.containsKey(dateKey)) {
              groupedLogs[dateKey] = [];
            }
            groupedLogs[dateKey]!.add(log);
          }

          return ListView(
            children: groupedLogs.entries.map((entry) {
              final date = DateFormat('MMMM dd, yyyy').format(DateTime.parse(entry.key));
              final dayLogs = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      date,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...dayLogs.map((log) {
                    final data = log.data() as Map<String, dynamic>;
                    final timestamp = (data['timestamp'] as Timestamp).toDate();
                    final time = DateFormat('HH:mm').format(timestamp);

                    return Card(
                      color: const Color.fromRGBO(43, 39, 176, 1),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text(
                          '${data['food_name'] ?? 'Unknown'}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '⏰ $time\n'
                                '🔥 Calories: ${_formatNumber(data['calories'])} kcal\n'
                                '🥩 Protein: ${_formatNumber(data['protein'])} g | '
                                '🍚 Carbs: ${_formatNumber(data['carbs'])} g | '
                                '🛢️ Fat: ${_formatNumber(data['fat'])} g',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteLog(log.id),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return 'N/A';
    if (value is num) {
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }

  void _deleteLog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
        title: const Text('Delete Log', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this log?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await _logsCollection.doc(docId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Log deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
