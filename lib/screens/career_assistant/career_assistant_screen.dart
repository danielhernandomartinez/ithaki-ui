import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'models/chat_message.dart';
import 'models/chat_mock_data.dart';
import 'widgets/chat_action_chip.dart';
import 'widgets/chat_header_card.dart';
import 'widgets/chat_history_sheet.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_menu_item.dart';
import 'widgets/chat_message_bubble.dart';

import 'widgets/search_in_chats_sheet.dart';

class CareerAssistantScreen extends ConsumerStatefulWidget {
  const CareerAssistantScreen({super.key});

  @override
  ConsumerState<CareerAssistantScreen> createState() =>
      _CareerAssistantScreenState();
}

class _CareerAssistantScreenState extends ConsumerState<CareerAssistantScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();

  final List<ChatMessage> _messages = [];
  bool _thinking = false;
  bool _showInitialChips = true;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
    _messages.add(const ChatMessage(type: MsgType.ai, text: kInitialAiText));
  }

  @override
  void dispose() {
    _panels.dispose();
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Scroll
  // ---------------------------------------------------------------------------

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Chat actions
  // ---------------------------------------------------------------------------

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _thinking) return;
    _inputFocus.unfocus();
    _inputController.clear();
    setState(() {
      _showInitialChips = false;
      _messages.add(ChatMessage(type: MsgType.user, text: trimmed));
      _thinking = true;
    });
    _scrollToBottom();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _thinking = false;
      _messages.add(buildAiResponse(trimmed));
    });
    _scrollToBottom();
  }

  void _toggleMenu() {
    _inputFocus.unfocus();
    _panels.toggleMenu();
  }

  void _toggleProfile() {
    _inputFocus.unfocus();
    _panels.toggleProfile();
  }

  void _goFromMenu(String route) {
    _inputFocus.unfocus();
    _panels.closeMenu();
    _panels.closeProfile();
    if (route != Routes.careerAssistant) context.go(route);
  }

  void _pushFromProfile(String route) {
    _inputFocus.unfocus();
    _panels.closeProfile();
    if (route.isNotEmpty) context.push(route);
  }

  void _newChat() {
    setState(() {
      _messages
        ..clear()
        ..add(const ChatMessage(type: MsgType.ai, text: kInitialAiText));
      _showInitialChips = true;
      _thinking = false;
    });
  }

  void _showHistory() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const ChatHistorySheet(),
      );

  void _showSearchInChats() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SearchInChatsSheet(),
      );

  Future<void> _showMenu(BuildContext ctx) async {
    _inputFocus.unfocus();
    final overlay =
        Navigator.of(ctx).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(MediaQuery.of(ctx).size.width - 60, kToolbarHeight + 80, 1, 1),
      Offset.zero & overlay.size,
    );
    final result = await showMenu<String>(
      context: ctx,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: const [
        PopupMenuItem(
          value: 'new',
          child: ChatMenuItem(icon: 'edit-pencil', label: 'New Chat'),
        ),
        PopupMenuItem(
          value: 'search',
          child: ChatMenuItem(icon: 'search', label: 'Search in Chats'),
        ),
        PopupMenuItem(
          value: 'history',
          child: ChatMenuItem(icon: 'resume', label: "Chat's History"),
        ),
      ],
    );
    if (!mounted) return;
    switch (result) {
      case 'new':
        _newChat();
      case 'search':
        _showSearchInChats();
      case 'history':
        _showHistory();
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  Widget _panel(double topOffset, Widget child) => Positioned(
        top: topOffset - 14,
        left: 16,
        right: 16,
        bottom: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: child,
        ),
      );

  Widget _buildChatList() {
    final extraCount = (_showInitialChips ? 1 : 0) + (_thinking ? 1 : 0);
    final totalCount = _messages.length + extraCount;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        // Show initial chips after the first AI message
        if (_showInitialChips && index == 1) {
          return ChatInitialChipsRow(
            chips: kInitialChips,
            onChip: _sendMessage,
          );
        }

        final msgIndex = (_showInitialChips && index > 1) ? index - 1 : index;

        if (_thinking && msgIndex == _messages.length) {
          return const ThinkingBubble();
        }

        if (msgIndex >= _messages.length) return const SizedBox.shrink();
        return ChatMessageBubble(msg: _messages[msgIndex], onChip: _sendMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider).value;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: homeData?.userInitials ?? 'CI',
        onMenuPressed: _toggleMenu,
        onAvatarPressed: _toggleProfile,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ChatHeaderCard(onMenu: () => _showMenu(context)),
              Expanded(child: _buildChatList()),
              ChatInputBar(
                controller: _inputController,
                focusNode: _inputFocus,
                onSend: _sendMessage,
              ),

            ],
          ),
          // Dismiss overlay sits behind the panels so menu items remain tappable.
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _panels.closeMenu();
                  _panels.closeProfile();
                },
                behavior: HitTestBehavior.translucent,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          // Nav drawer
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.careerAssistant,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: kAppNavItems,
                  onItemTap: (item) => _goFromMenu(item.route),
                ),
              ),
            ),
          // Profile panel
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
                position: _panels.profileSlideAnim,
                child: ProfileMenuPanel(
                  onItemTap: (item) => _pushFromProfile(item.route),
                  onLogOut: () {
                    _inputFocus.unfocus();
                    _panels.closeProfile();
                    ref.read(authRepositoryProvider).logout().whenComplete(() {
                      resetProfileProviders(ref);
                      if (context.mounted) context.go(Routes.root);
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
