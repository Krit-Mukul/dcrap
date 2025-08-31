import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  // Simulate user's current points and level
  final int userPoints = 4200;

  final List<Map<String, dynamic>> ranks = const [
    {
      'name': 'Green Leaf',
      'desc': 'Start your journey. Earn points for every eco action.',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF43A047),
      'points': 0,
      'benefits': [
        'Access to basic recycling rewards',
        'Monthly eco tips',
        'Track your impact'
      ],
    },
    {
      'name': 'Silver Leaf',
      'desc': 'Level up! Unlock exclusive eco rewards and tips.',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFB0BEC5),
      'points': 2000,
      'benefits': [
        'Priority pickups',
        'Exclusive silver rewards',
        'Early access to eco events'
      ],
    },
    {
      'name': 'Gold Branch',
      'desc': 'Top contributor! Get premium benefits and recognition.',
      'icon': Icons.emoji_events_rounded,
      'color': Color(0xFFFFD600),
      'points': 5000,
      'benefits': [
        'Premium rewards & cashback',
        'VIP support',
        'Featured in leaderboard'
      ],
    },
    {
      'name': '???',
      'desc': 'A mysterious rank awaits. Get closer to discover!',
      'icon': Icons.help_outline_rounded,
      'color': Color(0xFF6C4AB6),
      'points': 10000,
      'benefits': [
        'Secret rewards',
        'Personal eco advisor',
        'Invitation to exclusive events'
      ],
    },
  ];

  int get currentLevel {
    for (int i = ranks.length - 1; i >= 0; i--) {
      if (userPoints >= ranks[i]['points']) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final level = currentLevel;
    final nextLevel = level < ranks.length - 1 ? level + 1 : level;
    final progressToNext = level < ranks.length - 1
        ? (userPoints - (ranks[level]['points'] as int)) /
            ((ranks[nextLevel]['points'] as int) - (ranks[level]['points'] as int))
        : 1.0;

    return Scaffold(
      appBar: AppBar(title: Text(
              'Your Eco Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color:  Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // const SizedBox(height: 18),
            // Progress bar
            Container(
              decoration: BoxDecoration(
                color: (ranks[level]['color'] as Color).withOpacity(0.13),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(ranks[level]['icon'] as IconData, color: ranks[level]['color'] as Color, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ranks[level]['name'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: ranks[level]['color'] as Color,
                              ),
                            ),
                            Text(
                              ranks[level]['desc'] as String,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$userPoints pts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ranks[level]['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  LinearProgressIndicator(
                    value: progressToNext.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(ranks[level]['color'] as Color),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ranks[level]['points']} pts',
                        style: TextStyle(color: ranks[level]['color'] as Color, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        level < ranks.length - 1
                            ? '${ranks[nextLevel]['name']} at ${ranks[nextLevel]['points']} pts'
                            : 'Max Level',
                        style: TextStyle(
                          color: ranks[nextLevel]['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Benefits:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ranks[level]['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (ranks[level]['benefits'] as List).length,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              (ranks[level]['benefits'] as List)[i],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Upcoming Levels',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // Show next levels
            ...ranks.asMap().entries.where((e) => e.key > level).map((e) {
              final rank = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: (rank['color'] as Color).withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: rank['color'] as Color, width: 1.1),
                ),
                child: ListTile(
                  leading: Icon(rank['icon'] as IconData, color: rank['color'] as Color, size: 32),
                  title: Text(
                    rank['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: rank['color'] as Color,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rank['desc'] as String,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unlocks at ${rank['points']} pts',
                        style: TextStyle(
                          fontSize: 13,
                          color: rank['color'] as Color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Benefits:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: rank['color'] as Color,
                        ),
                      ),
                      ...List.generate(
                        (rank['benefits'] as List).length,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, color: Colors.grey, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  (rank['benefits'] as List)[i],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: rank['name'] == '???'
                      ? const Icon(Icons.lock_outline_rounded, color: Colors.deepPurple)
                      : null,
                ),
              );
            }),
            const SizedBox(height: 24),
            Text(
              'Earn points by recycling, sharing tips, and inviting friends. Unlock new ranks and rewards as you progress!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}