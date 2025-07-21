import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/training_sessions_screen.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isLoading = true;
  int _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadLocalUserData();
  }

  Future<void> _loadLocalUserData() async {
    final dbService = DatabaseService();
    // Try to get the first user (for single-user local app)
    User? user;
    final db = await dbService.database;
    final users = await db.query('users');
    if (users.isNotEmpty) {
      final data = users.first;
      user = User(
        id: data['id'] as int,
        username: data['username'] as String,
        email: data['email'] as String,
        dojo: data['dojo'] as String?,
        // Stats fields can be calculated from sessions if needed
      );
    } else {
      // Create a default user if none exists
      final defaultUser = User(
          id: 0,
          username: widget.username,
          email: 'local@example.com',
          dojo: 'Local Dojo');
      final userId = await dbService.addUser(defaultUser);
      user = User(
          id: userId,
          username: defaultUser.username,
          email: defaultUser.email,
          dojo: defaultUser.dojo);
    }
    // Calculate total duration
    int totalDuration = 0;
    if (user != null) {
      final sessions = await dbService.getTrainingSessions(user.id);
      totalDuration = sessions.fold(0, (sum, s) => sum + (s.duration));
    }
    setState(() {
      _user = user;
      _totalDuration = totalDuration;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Failed to load user data'))
              : RefreshIndicator(
                  onRefresh: _loadLocalUserData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsCard(),
                        const SizedBox(height: 16),
                        _buildQuickActions(),
                        const SizedBox(height: 16),
                        _buildTechniquesCard(),
                        const SizedBox(height: 16),
                        _buildSessionTypesCard(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Training Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Sessions', _user!.sessions.toString()),
                _buildStatItem(
                    'This Month', _user!.sessionsThisMonth.toString()),
                _buildStatItem('This Year', _user!.sessionsThisYear.toString()),
                _buildStatItem('Total Duration',
                    '${_totalDuration} min\n(${(_totalDuration / 60).toStringAsFixed(1)} h)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.add,
                  label: 'Add Session',
                  onTap: () {
                    // Optionally, navigate to training sessions screen or add session dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainingSessionsScreen(userId: _user!.id),
                      ),
                    ).then((_) => _loadLocalUserData());
                  },
                ),
                _buildActionButton(
                  icon: Icons.list,
                  label: 'View Sessions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainingSessionsScreen(userId: _user!.id),
                      ),
                    ).then((_) => _loadLocalUserData());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniquesCard() {
    final techniques = _user!.techniques.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Techniques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (techniques.isEmpty)
              const Text('No techniques recorded yet')
            else
              ...techniques.take(5).map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key
                            .replaceAll('-', ' ')
                            .split(' ')
                            .map((word) => word.isEmpty
                                ? word
                                : word[0].toUpperCase() + word.substring(1))
                            .join(' ')),
                        Text(entry.value.toString()),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTypesCard() {
    final sessionTypes = _user!.sessionTypes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (sessionTypes.isEmpty)
              const Text('No session types recorded yet')
            else
              ...sessionTypes.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key
                            .replaceAll('-', ' ')
                            .split(' ')
                            .map((word) => word.isEmpty
                                ? word
                                : word[0].toUpperCase() + word.substring(1))
                            .join(' ')),
                        Text(entry.value.toString()),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
