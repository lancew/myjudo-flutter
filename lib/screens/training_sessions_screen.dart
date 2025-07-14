import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/training_session.dart';
import 'package:intl/intl.dart';

class TrainingSessionsScreen extends StatefulWidget {
  final int userId;

  const TrainingSessionsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TrainingSessionsScreen> createState() => _TrainingSessionsScreenState();
}

class _TrainingSessionsScreenState extends State<TrainingSessionsScreen> {
  List<TrainingSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final sessions = await apiService.getTrainingSessions(widget.userId);
    
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add session screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add session feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_martial_arts, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No training sessions yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first session',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSessions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      final session = _sessions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.sports_martial_arts),
                          ),
                          title: Text(
                            session.dojo ?? 'Training Session',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy').format(DateTime.parse(session.date)),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (session.techniques.isNotEmpty)
                                Text(
                                  'Techniques: ${session.techniques.take(3).join(', ')}${session.techniques.length > 3 ? '...' : ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              if (session.types.isNotEmpty)
                                Text(
                                  'Types: ${session.types.join(', ')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // TODO: Navigate to edit session screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Edit session feature coming soon')),
                              );
                            },
                          ),
                          onTap: () {
                            _showSessionDetails(session);
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showSessionDetails(TrainingSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session.dojo ?? 'Training Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(session.date))}'),
            const SizedBox(height: 8),
            if (session.techniques.isNotEmpty) ...[
              const Text('Techniques:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...session.techniques.map((tech) => Text('• ${tech.replaceAll('-', ' ')}')),
              const SizedBox(height: 8),
            ],
            if (session.types.isNotEmpty) ...[
              const Text('Training Types:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...session.types.map((type) => Text('• ${type.replaceAll('-', ' ')}')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
