import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'profile_model.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<ProfileModel> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final result = await context.read<UserProvider>().getLeaderboard();
    if (mounted) {
      setState(() {
        leaderboard = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: const Text('Жетістіктер', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 191, 88, 209),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMyStatsSection(),
            const SizedBox(height: 30),
            const Text(
              "Мектептің үздіктері 🏆", // Рейтинг
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            _buildLeaderboardSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyStatsSection() {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.user;

    if (profile == null) {
      return const Center(child: Text("Пайдаланушы деректері жоқ"));
    }

    final int answers = profile.answeredQuestions;
    final int games = profile.gamesPlayed;
    final int pts = profile.points;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 40),
              const SizedBox(width: 10),
              Text(
                "Сенің ұпайың: $pts", // Твой рейтинг (kaz)
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.check_circle_outline, Colors.green, answers.toString(), "Жауаптар"),
              _buildStatItem(Icons.videogame_asset, Colors.blue, games.toString(), "Ойналған ойындар"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, Color color, String count, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildLeaderboardSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (leaderboard.isEmpty) {
      return const Center(child: Text("Әзірге рейтинг жоқ"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final user = leaderboard[index];
        final currentUser = context.read<UserProvider>().user;
        final bool isMe = currentUser != null && currentUser.email == user.email;

        return Card(
          elevation: isMe ? 4 : 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          color: isMe ? Colors.purple.shade50 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isMe ? const BorderSide(color: Colors.purple, width: 2) : BorderSide.none,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: index < 3 ? Colors.amber : Colors.grey.shade300,
              child: Text(
                "#${index + 1}",
                style: TextStyle(
                  color: index < 3 ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name,
              style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal),
            ),
            trailing: Text(
              "${user.points} оч.",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),
        );
      },
    );
  }
}
