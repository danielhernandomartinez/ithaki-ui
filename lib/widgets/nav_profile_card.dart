import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';

class NavProfileCard extends StatelessWidget {
  final double progress;
  const NavProfileCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.placeholderBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.homeProfileCompleteYourProfile,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 20,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 20),
                    painter: _HatchPainter(),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: IthakiTheme.navLime,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = IthakiTheme.placeholderBg,
    );
    final paint = Paint()
      ..color = IthakiTheme.hatchStripe
      ..strokeWidth = 1.5;
    const spacing = 8.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
          Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter old) => false;
}
