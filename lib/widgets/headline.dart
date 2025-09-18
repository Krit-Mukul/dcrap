import 'package:dcrap/models/phase.dart';
import 'package:flutter/material.dart';

class Headline extends StatefulWidget {
  const Headline({super.key});

  @override
  State<Headline> createState() => _HeadlineState();
}

class _HeadlineState extends State<Headline> with TickerProviderStateMixin {
  late AnimationController _outCtrl;
  late AnimationController _inCtrl;

  // Current word being shown
  String _currentWord = 'REWARDING';
  bool _nextIsRewarding = false; // next word toggle
  Phase _phase = Phase.hold;

  @override
  void initState() {
    super.initState();
    _outCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _inCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _startCycle(); // begin hold -> out -> in -> repeat
  }

  @override
  void dispose() {
    _outCtrl.dispose();
    _inCtrl.dispose();
    super.dispose();
  }

  Future<void> _startCycle() async {
    while (mounted) {
      // Hold (word steady)
      _phase = Phase.hold;
      if (mounted) setState(() {});
      await Future.delayed(const Duration(milliseconds: 1200));

      // Slide current word out to the right
      _phase = Phase.out;
      _outCtrl.value = 0;
      if (mounted) setState(() {});
      await _outCtrl.forward();

      // Swap word after it fully leaves
      _currentWord = _nextIsRewarding ? 'REWARDING' : 'EASIER';
      _nextIsRewarding = !_nextIsRewarding;

      // Slide new word in from the left to center (moving right)
      _phase = Phase.slideIn;
      _inCtrl.value = 0;
      if (mounted) setState(() {});
      await _inCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = const TextStyle(
      fontSize: 21,
      letterSpacing: .3,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );

    // Drive UI from both controllers
    return AnimatedBuilder(
      animation: Listenable.merge([_outCtrl, _inCtrl]),
      builder: (context, _) {
        // Compute horizontal fractional translation
        double dx = 0;
        switch (_phase) {
          case Phase.hold:
            dx = 0;
            break;
          case Phase.out:
            dx = _outCtrl.value * 1.2; // 0 -> +1.2 (move right off-screen)
            break;
          case Phase.slideIn:
            dx =
                -1.2 +
                _inCtrl.value * 1.2; // -1.2 -> 0 (enter from left moving right)
            break;
        }

        return Column(
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'RECYCLING MADE ',
                    style: baseStyle,
                    textAlign: TextAlign.left,
                  ),
                  // Clip so text can slide fully off without affecting layout
                  ClipRect(
                    child: FractionalTranslation(
                      translation: Offset(dx, 0),
                      child: Text(
                        _currentWord,
                        style: baseStyle.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
