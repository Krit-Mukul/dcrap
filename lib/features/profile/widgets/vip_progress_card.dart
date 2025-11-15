import 'package:flutter/material.dart';
import 'package:dcrap/features/explore/screens/explore_screen.dart';
import 'package:dcrap/core/services/user_cache_service.dart';
import 'package:dcrap/core/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VipProgressCard extends StatefulWidget {
  const VipProgressCard({super.key});

  @override
  State<VipProgressCard> createState() => _VipProgressCardState();
}

class _VipProgressCardState extends State<VipProgressCard> {
  String _userName = 'User';
  double _vipProgress = 0.0;
  String _vipLevel = 'None';
  int _totalOrders = 0;
  double _totalEarnings = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Try to load from cache first
    final cachedName = await UserCacheService.getUserName();
    debugPrint('📦 Cached username: $cachedName');

    // Also load from Firestore to verify
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final firestoreName = doc.data()?['name'] as String?;
        debugPrint('🔥 Firestore username: $firestoreName');

        // If Firestore has a name, use it and update cache
        if (firestoreName != null && firestoreName.isNotEmpty) {
          await UserCacheService.saveUser(
            userId: user.uid,
            userName: firestoreName,
            userPhone: doc.data()?['phone'] ?? '',
          );

          if (mounted) {
            setState(() {
              _userName = firestoreName;
            });
          }
          debugPrint('✅ Updated username to: $firestoreName');
        } else if (cachedName != null && cachedName.isNotEmpty) {
          // Fallback to cached name
          if (mounted) {
            setState(() {
              _userName = cachedName;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading username: $e');
      // Fallback to cached name if Firestore fails
      if (cachedName != null && cachedName.isNotEmpty && mounted) {
        setState(() {
          _userName = cachedName;
        });
      }
    }

    // Also load VIP progress from backend to create entry if doesn't exist
    try {
      final vipData = await ApiService.getVipProgress();
      debugPrint('✅ VIP Progress loaded from backend: ${vipData['data']}');

      if (mounted) {
        setState(() {
          _vipProgress =
              (vipData['data']['vipProgress'] as num?)?.toDouble() ?? 0.0;
          _vipLevel = vipData['data']['vipLevel'] as String? ?? 'None';
          _totalOrders = vipData['data']['totalOrders'] as int? ?? 0;
          _totalEarnings =
              (vipData['data']['totalEarnings'] as num?)?.toDouble() ?? 0.0;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load VIP progress: $e');
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pctText = '${(_vipProgress * 100).clamp(0, 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting row
          Row(
            children: [
              Text(
                'Hi $_userName,',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // VIP Progress title row
          Row(
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: scheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Your VIP Progress',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                pctText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: _vipProgress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          // Level tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'None',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _vipLevel,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ExploreScreen()));
            },
            child: const Text('Explore More...'),
          ),
        ],
      ),
    );
  }
}
