import 'package:flutter/material.dart';

class VipProgressPage extends StatelessWidget {
  final double progress; // 0.0 - 1.0

  const VipProgressPage({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pctText = '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%';
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      // vertical: ,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFECECEC),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Greeting row (icon removed)
                              Row(
                                children: [
                                  Text(
                                    'Hi Gamechangr,',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Smaller VIP Progress title row
                              Row(
                                children: [
                                  Icon(
                                    Icons.workspace_premium_rounded,
                                    color: scheme.primary,
                                    size: 18, // smaller icon
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Your VIP Progress',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall // smaller text
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  Text(
                                    pctText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium // smaller pct text
                                        ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Progress bar (full width)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Moved tags between progress bar and button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // smaller
                                    decoration: BoxDecoration(
                                      color: scheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'None',
                                      style: TextStyle(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11, // smaller
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // smaller
                                    decoration: BoxDecoration(
                                      color: scheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      progress < 1.0 ? 'Bronze' : 'Silver',
                                      style: TextStyle(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11, // smaller
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () {},
                                child: const Text('Explore More...'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Pill-shaped cards below VIP Progress, full width and rounded card style
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // TODO: Add navigation or action
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.shopping_bag_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'My Orders',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const AutoPickupPage()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.autorenew_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Auto Pickups',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // TODO: Add navigation or action
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.location_on_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Saved Addresses',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // TODO: Add navigation or action
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.card_giftcard_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'My Rewards',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.emoji_events_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Leaderboard',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // TODO: Add navigation or action
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.support_agent_rounded, size: 22, color: Colors.black54),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Live Support',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Contact us:',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'support@dcrap.com',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        ' | +91 993891283',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 120), // was 50: extra bottom space
                                ],
              
                              ),
                            ),
                          ],
                        ),
                      ],
                      ),
                    ),
                ),
                  ],
            ),
                ),
              ),
            ),
          );
        
  }
}

// Add this page to the bottom of the file
class AutoPickupPage extends StatelessWidget {
  const AutoPickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Automatic Pickups')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.event_repeat_rounded, color: scheme.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Set up recurring pickups (e.g., every 2 weeks). View, edit, or cancel your schedules.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text('No automatic pickups yet', style: TextStyle(color: Colors.black54)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // TODO: Wire to creation flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Set up automatic pickup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? scheme.primary.withOpacity(0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isMe ? Border.all(color: scheme.primary, width: 1.2) : null,
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
                          backgroundColor: isTop ? scheme.primary : Colors.grey.shade300,
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
                                    const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    row['name'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: isMe ? scheme.primary : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                row['location'] as String, // show City, State
                                style: TextStyle(color: Colors.black54, fontSize: 12),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  // Overall by default; city/state shown per row; includes many entries for scrollability
  List<Map<String, dynamic>> _rankings({required bool global}) {
    final localOverall = [
      {'name': 'Aarav', 'points': 12340, 'location': 'Chandigarh, Chandigarh'},
      {'name': 'You', 'points': 11980, 'location': 'Patiala, Punjab', 'isYou': true},
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
      {'name': 'You', 'points': 17180, 'location': 'Patiala, Punjab', 'isYou': true},
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
            Icon(icon, size: 20, color: selected ? scheme.primary : Colors.black54),
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
