// lib/widgets/success_banner.dart
import 'package:flutter/material.dart';

/// Dark graphite toast banner shown below the AppBar.
/// Slides down, stays 3 s, slides back up.
///
/// Usage:
///   SuccessBanner.show(context, 'Your email has been changed.');
class SuccessBanner {
  static OverlayEntry? _current;

  static void show(BuildContext context, String message) {
    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _BannerWidget(
        message: message,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    Overlay.of(context).insert(entry);
    _current = entry;
  }
}

class _BannerWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _BannerWidget({required this.message, required this.onDismiss});

  @override
  State<_BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<_BannerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 3000), _dismiss);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF3D3D3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: _dismiss,
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
