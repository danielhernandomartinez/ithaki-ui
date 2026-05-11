import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/home_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../utils/ithaki_bottom_sheet.dart';
import '../../widgets/main_panel_scaffold.dart';
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

class _CareerAssistantScreenState extends ConsumerState<CareerAssistantScreen> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocus = FocusNode();

  final List<ChatMessage> _messages = [];
  bool _thinking = false;
  bool _showInitialChips = true;

  @override
  void initState() {
    super.initState();
    _messages.add(const ChatMessage(type: MsgType.ai, text: kInitialAiText));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

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

  void _newChat() {
    setState(() {
      _messages
        ..clear()
        ..add(const ChatMessage(type: MsgType.ai, text: kInitialAiText));
      _showInitialChips = true;
      _thinking = false;
    });
  }

  void _showHistory() => showIthakiBottomSheet<void>(
        context: context,
        builder: (_) => const ChatHistorySheet(),
      );

  void _showSearchInChats() => showIthakiBottomSheet<void>(
        context: context,
        builder: (_) => const SearchInChatsSheet(),
      );

  Future<void> _showMenu(BuildContext ctx) async {
    _inputFocus.unfocus();
    final l10n = AppLocalizations.of(ctx)!;
    final overlay =
        Navigator.of(ctx).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromLTWH(
        MediaQuery.of(ctx).size.width - 60,
        kToolbarHeight + 80,
        1,
        1,
      ),
      Offset.zero & overlay.size,
    );
    final result = await showMenu<String>(
      context: ctx,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          value: 'new',
          child: ChatMenuItem(icon: 'edit-pencil', label: l10n.chatNewChat),
        ),
        PopupMenuItem(
          value: 'search',
          child: ChatMenuItem(icon: 'search', label: l10n.chatSearchInChats),
        ),
        PopupMenuItem(
          value: 'history',
          child: ChatMenuItem(icon: 'resume', label: l10n.chatHistory),
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

  Widget _buildChatList() {
    final extraCount = (_showInitialChips ? 1 : 0) + (_thinking ? 1 : 0);
    final totalCount = _messages.length + extraCount;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      itemCount: totalCount,
      itemBuilder: (context, index) {
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
        return ChatMessageBubble(
          msg: _messages[msgIndex],
          onChip: _sendMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider).value;
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);

    return MainPanelScaffold(
      currentRoute: Routes.careerAssistant,
      extendBodyBehindAppBar: false,
      avatarInitials: homeData?.userInitials ?? 'CI',
      avatarUrl: homeData?.userPhotoUrl,
      onBeforePanelAction: _inputFocus.unfocus,
      bodyBuilder: (context, ref, topOffset) => Column(
        children: [
          KeyedSubtree(
            key: tourState?.currentStep == 11 ? tourKeys[11] : null,
            child: ChatHeaderCard(onMenu: () => _showMenu(context)),
          ),
          Expanded(child: _buildChatList()),
          ChatInputBar(
            controller: _inputController,
            focusNode: _inputFocus,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
