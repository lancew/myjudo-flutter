import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/training_sessions_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalUserData();
  }

  Future<void> _loadLocalUserData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Create mock user data for local-first experience
    final mockUser = User(
      id: 1,
      username: widget.username,
      email: 'local@example.com',
      dojo: 'Local Dojo',
      sessions: 12,
      sessionsThisMonth: 4,
      sessionsLastMonth: 6,
      sessionsThisYear: 45,
      sessionsLastYear: 38,
      sessionTypes: {
        'randori-tachi-waza': 8,
        'randori-ne-waza': 6,
        'uchi-komi': 15,
        'nage-komi': 10,
        'kata': 3,
      },
      techniques: {
        'o-soto-gari': 25,
        'seoi-nage': 20,
        'tai-otoshi': 15,
        'ko-uchi-gari': 12,
        'kesa-gatame': 8,
      },
      techniquesThisMonth: {
        'o-soto-gari': 8,
        'seoi-nage': 6,
        'tai-otoshi': 4,
      },
      techniquesLastMonth: {
        'o-soto-gari': 10,
        'seoi-nage': 8,
        'tai-otoshi': 6,
      },
      techniquesThisYear: {
        'o-soto-gari': 25,
        'seoi-nage': 20,
        'tai-otoshi': 15,
      },
    );

    setState(() {
      _user = mockUser;
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
                    // TODO: Navigate to add session screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Add session feature coming soon')),
                    );
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
                    );
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
