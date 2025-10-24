import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _global = false; // false = Local, true = Global

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final data = _rankings(global: _global);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Info',
            onPressed: _showInfo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _modeButton(
                    context,
                    label: 'Local',
                    icon: Icons.location_on_rounded,
                    selected: !_global,
                    onTap: () => setState(() => _global = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _modeButton(
                    context,
                    label: 'Global',
                    icon: Icons.public_rounded,
                    selected: _global,
                    onTap: () => setState(() => _global = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final row = data[i];
                  final rank = i + 1;
                  final isTop = rank <= 3;
                  final isMe = row['isYou'] == true;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? scheme.primary.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isMe
                          ? Border.all(color: scheme.primary, width: 1.2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: isTop
                              ? scheme.primary
                              : Colors.grey.shade300,
                          child: Text(
                            '$rank',
                            style: TextStyle(
                              color: isTop ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (rank == 1) ...[
                                    const Icon(
                                      Icons.emoji_events_rounded,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    row['name'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: isMe
                                          ? scheme.primary
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                row['location'] as String,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${row['points']} pts',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isMe ? scheme.primary : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leaderboard Info'),
        content: const Text(
          'The leaderboard resets on the first of every month.\n\n'
          'For overall contributors, please visit our website.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _rankings({required bool global}) {
    final localOverall = [
      {'name': 'Aarav', 'points': 12340, 'location': 'Chandigarh, Chandigarh'},
      {
        'name': 'You',
        'points': 11980,
        'location': 'Patiala, Punjab',
        'isYou': true,
      },
      {'name': 'Isha', 'points': 11210, 'location': 'Mohali, Punjab'},
      {'name': 'Kabir', 'points': 10820, 'location': 'Ludhiana, Punjab'},
      {'name': 'Sara', 'points': 10330, 'location': 'Ambala, Haryana'},
      {'name': 'Rohan', 'points': 9820, 'location': 'Panchkula, Haryana'},
      {'name': 'Neha', 'points': 9510, 'location': 'Jalandhar, Punjab'},
      {'name': 'Vikram', 'points': 9260, 'location': 'Amritsar, Punjab'},
      {'name': 'Aditi', 'points': 9050, 'location': 'Patiala, Punjab'},
      {'name': 'Dev', 'points': 8810, 'location': 'Chandigarh, Chandigarh'},
      {'name': 'Meera', 'points': 8600, 'location': 'Mohali, Punjab'},
      {'name': 'Rahul', 'points': 8420, 'location': 'Ludhiana, Punjab'},
      {'name': 'Pooja', 'points': 8290, 'location': 'Ambala, Haryana'},
      {'name': 'Kunal', 'points': 8150, 'location': 'Panchkula, Haryana'},
      {'name': 'Anya', 'points': 7990, 'location': 'Jalandhar, Punjab'},
      {'name': 'Ira', 'points': 7830, 'location': 'Amritsar, Punjab'},
      {'name': 'Naman', 'points': 7710, 'location': 'Patiala, Punjab'},
      {'name': 'Zara', 'points': 7600, 'location': 'Chandigarh, Chandigarh'},
      {'name': 'Ria', 'points': 7480, 'location': 'Mohali, Punjab'},
      {'name': 'Samar', 'points': 7350, 'location': 'Ludhiana, Punjab'},
    ];

    final globalOverall = [
      {'name': 'Emma', 'points': 22040, 'location': 'Seattle, WA'},
      {'name': 'Liam', 'points': 21910, 'location': 'Dublin, Leinster'},
      {'name': 'Olivia', 'points': 21580, 'location': 'London, UK'},
      {'name': 'Noah', 'points': 21220, 'location': 'Austin, TX'},
      {'name': 'Ava', 'points': 20990, 'location': 'Toronto, ON'},
      {'name': 'Sophia', 'points': 20510, 'location': 'Barcelona, Spain'},
      {'name': 'Mason', 'points': 20340, 'location': 'Sydney, NSW'},
      {'name': 'Mia', 'points': 19980, 'location': 'Berlin, Germany'},
      {'name': 'James', 'points': 19740, 'location': 'New York, NY'},
      {'name': 'Amelia', 'points': 19510, 'location': 'Paris, France'},
      {'name': 'Ethan', 'points': 19220, 'location': 'Singapore, SG'},
      {'name': 'Harper', 'points': 18950, 'location': 'Oslo, Norway'},
      {'name': 'Logan', 'points': 18680, 'location': 'Zurich, Switzerland'},
      {'name': 'Aria', 'points': 18430, 'location': 'Rome, Italy'},
      {'name': 'Jackson', 'points': 18110, 'location': 'Boston, MA'},
      {'name': 'Avery', 'points': 17860, 'location': 'Vancouver, BC'},
      {'name': 'Scarlett', 'points': 17640, 'location': 'Lisbon, Portugal'},
      {'name': 'Henry', 'points': 17310, 'location': 'Stockholm, Sweden'},
      {
        'name': 'You',
        'points': 17180,
        'location': 'Patiala, Punjab',
        'isYou': true,
      },
      {'name': 'Ella', 'points': 16990, 'location': 'Brisbane, QLD'},
    ];

    return global ? globalOverall : localOverall;
  }

  Widget _modeButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? scheme.primary : const Color(0xFFECECEC),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? scheme.primary : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? scheme.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
