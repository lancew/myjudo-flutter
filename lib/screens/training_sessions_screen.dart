import 'package:flutter/material.dart';
import '../models/training_session.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class TrainingSessionsScreen extends StatefulWidget {
  final int userId;

  const TrainingSessionsScreen({super.key, required this.userId});

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
    setState(() {
      _isLoading = true;
    });
    final dbService = DatabaseService();
    final sessions = await dbService.getTrainingSessions(widget.userId);
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
            onPressed: _showAddSessionDialog,
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
                      Icon(Icons.sports_martial_arts,
                          size: 64, color: Colors.grey),
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
                                DateFormat('MMM dd, yyyy')
                                    .format(DateTime.parse(session.date)),
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showEditSessionDialog(session),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteSession(session.id!),
                              ),
                            ],
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
            Text(
                'Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(session.date))}'),
            const SizedBox(height: 8),
            if (session.techniques.isNotEmpty) ...[
              const Text('Techniques:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...session.techniques
                  .map((tech) => Text('• ${tech.replaceAll('-', ' ')}')),
              const SizedBox(height: 8),
            ],
            if (session.types.isNotEmpty) ...[
              const Text('Training Types:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...session.types
                  .map((type) => Text('• ${type.replaceAll('-', ' ')}')),
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

  void _showAddSessionDialog() async {
    final formKey = GlobalKey<FormState>();
    String date = DateTime.now().toIso8601String().split('T')[0];
    String dojo = '';
    String techniques = '';
    String types = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Training Session'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: date,
                  decoration:
                      const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  onChanged: (v) => date = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter date' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Dojo'),
                  onChanged: (v) => dojo = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Techniques (comma separated)'),
                  onChanged: (v) => techniques = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Types (comma separated)'),
                  onChanged: (v) => types = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final session = TrainingSession(
                  date: date,
                  dojo: dojo.isEmpty ? null : dojo,
                  userId: widget.userId,
                  techniques: techniques
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  types: types
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                );
                await DatabaseService().addTrainingSession(session);
                if (mounted) {
                  Navigator.pop(context);
                  await _loadSessions();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditSessionDialog(TrainingSession session) async {
    final formKey = GlobalKey<FormState>();
    String date = session.date;
    String dojo = session.dojo ?? '';
    String techniques = session.techniques.join(', ');
    String types = session.types.join(', ');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Training Session'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: date,
                  decoration:
                      const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  onChanged: (v) => date = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter date' : null,
                ),
                TextFormField(
                  initialValue: dojo,
                  decoration: const InputDecoration(labelText: 'Dojo'),
                  onChanged: (v) => dojo = v,
                ),
                TextFormField(
                  initialValue: techniques,
                  decoration: const InputDecoration(
                      labelText: 'Techniques (comma separated)'),
                  onChanged: (v) => techniques = v,
                ),
                TextFormField(
                  initialValue: types,
                  decoration: const InputDecoration(
                      labelText: 'Types (comma separated)'),
                  onChanged: (v) => types = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final updated = session.copyWith(
                  date: date,
                  dojo: dojo.isEmpty ? null : dojo,
                  techniques: techniques
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  types: types
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                );
                await DatabaseService().updateTrainingSession(updated);
                if (mounted) {
                  Navigator.pop(context);
                  await _loadSessions();
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSession(int id) async {
    await DatabaseService().deleteTrainingSession(id);
    await _loadSessions();
  }
}
