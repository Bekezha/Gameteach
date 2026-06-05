import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/level_helper.dart';
import 'achievements_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchProfile();
    });
  }

  Future<void> _logout() async {
    await context.read<UserProvider>().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.user;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final levelInfo = LevelHelper.getLevelInfo(profile.points);
    final progress = levelInfo.getProgress(profile.points);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Level Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    // Medal Image
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        "assets/images/levels/${levelInfo.assetName}.png",
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.emoji_events,
                          size: 100,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      levelInfo.level < 10 ? levelInfo.titleKk : "Ғарыш әміршісі",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Деңгей ${levelInfo.level}",
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${profile.points} ұпай", style: const TextStyle(color: Colors.white60)),
                        if (levelInfo.level < 10)
                          Text("${levelInfo.maxPoints} ұпай", style: const TextStyle(color: Colors.white60)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // User Details
              _buildInfoTile(Icons.person, "Аты-жөні", profile.name),
              _buildInfoTile(Icons.email, "Email", profile.email),
              _buildInfoTile(Icons.quiz, "Шешілген сұрақтар", profile.answeredQuestions.toString()),
              _buildInfoTile(Icons.sports_esports, "Ойналған ойындар", profile.gamesPlayed.toString()),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                    );
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Жетістіктер'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Шығу'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
