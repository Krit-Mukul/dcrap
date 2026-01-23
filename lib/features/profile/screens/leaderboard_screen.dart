import 'package:flutter/material.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _sortBy = 'totalOrders'; // 'totalOrders' or 'earnings'
  List<Map<String, dynamic>> _leaderboard = [];
  bool _loading = true;
  String? _error;
  int? _userRank;
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await ApiService.getLeaderboard(sortBy: _sortBy, limit: 100);

      final leaderboard = (data['data'] as List).cast<Map<String, dynamic>>();

      // Find user's rank
      final userIndex = leaderboard.indexWhere(
        (item) => item['uid'] == _currentUserId,
      );

      setState(() {
        _leaderboard = leaderboard;
        _userRank = userIndex != -1 ? userIndex + 1 : null;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      // print('❌ Failed to load leaderboard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _loadLeaderboard,
          ),
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
            // Sort options
            Row(
              children: [
                Expanded(
                  child: _modeButton(
                    context,
                    label: 'By Orders',
                    icon: Icons.shopping_bag_rounded,
                    selected: _sortBy == 'totalOrders',
                    onTap: () {
                      setState(() => _sortBy = 'totalOrders');
                      _loadLeaderboard();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _modeButton(
                    context,
                    label: 'By Earnings',
                    icon: Icons.currency_rupee_rounded,
                    selected: _sortBy == 'earnings',
                    onTap: () {
                      setState(() => _sortBy = 'earnings');
                      _loadLeaderboard();
                    },
                  ),
                ),
              ],
            ),

            // User's rank card
            if (_userRank != null && !_loading) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.primary, width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      color: scheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Rank',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '#$_userRank of ${_leaderboard.length}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_leaderboard.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _sortBy == 'totalOrders' ? 'Orders' : 'Earnings',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            _sortBy == 'totalOrders'
                                ? '${_leaderboard[_userRank! - 1]['totalOrders']}'
                                : '₹${_leaderboard[_userRank! - 1]['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load leaderboard',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadLeaderboard,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _leaderboard.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.leaderboard_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No rankings yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to start selling!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadLeaderboard,
                      child: ListView.separated(
                        itemCount: _leaderboard.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final row = _leaderboard[i];
                          final rank = i + 1;
                          final isTop = rank <= 3;
                          final isMe = row['uid'] == _currentUserId;

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
                                  ? Border.all(
                                      color: scheme.primary,
                                      width: 1.2,
                                    )
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
                                // Rank badge
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isTop
                                        ? _getRankColor(rank)
                                        : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: rank <= 3
                                        ? Icon(
                                            Icons.emoji_events_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Text(
                                            '$rank',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // User info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              row['displayName'] ?? 'User',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: isMe
                                                    ? scheme.primary
                                                    : Colors.black87,
                                                fontSize: 15,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isMe) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: scheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'YOU',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 12,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            row['phoneNumber'] ?? 'N/A',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (row['vipLevel'] != 'None' &&
                                              row['vipLevel'] != null) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: scheme.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .workspace_premium_rounded,
                                                    size: 10,
                                                    color: scheme.primary,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    row['vipLevel'],
                                                    style: TextStyle(
                                                      color: scheme.primary,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Stats
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _sortBy == 'totalOrders'
                                          ? '${row['totalOrders'] ?? 0}'
                                          : '₹${row['totalEarnings']?.toStringAsFixed(0) ?? '0'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: isMe
                                            ? scheme.primary
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      _sortBy == 'totalOrders'
                                          ? 'orders'
                                          : 'earned',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey.shade400; // Silver
      case 3:
        return Colors.brown.shade400; // Bronze
      default:
        return Colors.grey.shade300;
    }
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leaderboard Info'),
        content: const Text(
          'Rankings are based on your total completed orders or earnings.\n\n'
          'Complete more orders to climb the leaderboard!\n\n'
          'The leaderboard updates in real-time.',
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
