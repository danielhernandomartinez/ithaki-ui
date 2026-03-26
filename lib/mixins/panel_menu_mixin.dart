import 'package:flutter/material.dart';

/// Encapsulates the slide-down animation logic shared by screens
/// that have a hamburger nav drawer + profile avatar panel.
class PanelMenuController {
  late AnimationController menuCtrl;
  late Animation<Offset> slideAnim;
  bool menuOpen = false;

  late AnimationController profileCtrl;
  late Animation<Offset> profileSlideAnim;
  bool profileOpen = false;

  final void Function(VoidCallback) _setState;

  PanelMenuController(this._setState);

  void init(TickerProvider vsync) {
    menuCtrl = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 250));
    menuCtrl.addStatusListener((_) => _setState(() {}));
    slideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: menuCtrl, curve: Curves.easeOut));

    profileCtrl = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 250));
    profileCtrl.addStatusListener((_) => _setState(() {}));
    profileSlideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: profileCtrl, curve: Curves.easeOut));
  }

  void dispose() {
    menuCtrl.dispose();
    profileCtrl.dispose();
  }

  void toggleMenu() {
    if (profileOpen) closeProfile();
    _setState(() => menuOpen = !menuOpen);
    menuOpen ? menuCtrl.forward() : menuCtrl.reverse();
  }

  void closeMenu() {
    if (!menuOpen) return;
    _setState(() => menuOpen = false);
    menuCtrl.reverse();
  }

  void toggleProfile() {
    if (menuOpen) closeMenu();
    _setState(() => profileOpen = !profileOpen);
    profileOpen ? profileCtrl.forward() : profileCtrl.reverse();
  }

  void closeProfile() {
    if (!profileOpen) return;
    _setState(() => profileOpen = false);
    profileCtrl.reverse();
  }
}
