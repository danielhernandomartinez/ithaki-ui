import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:video_player/video_player.dart';

import '../l10n/app_localizations.dart';
import '../utils/parse_utils.dart';

class ProfileVideoPreview extends StatelessWidget {
  const ProfileVideoPreview({super.key, required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => ProfileVideoDialog.show(context, source),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 190,
          color: IthakiTheme.softGraphite,
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(minWidth: 88),
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: IthakiTheme.backgroundWhite.withValues(alpha: 0.64),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              l.playVideo,
              textAlign: TextAlign.center,
              style: IthakiTheme.bodySmall.copyWith(
                color: IthakiTheme.backgroundWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileVideoDialog extends StatelessWidget {
  const ProfileVideoDialog({super.key, required this.source});

  final String source;

  static Future<void> show(BuildContext context, String source) {
    return showDialog<void>(
      context: context,
      builder: (_) => ProfileVideoDialog(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final closeLabel = MaterialLocalizations.of(context).closeButtonLabel;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: IthakiTheme.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Semantics(
                    button: true,
                    label: closeLabel,
                    child: Center(
                      child: Text(
                        'x',
                        style: IthakiTheme.headingMedium.copyWith(
                          color: IthakiTheme.textPrimary,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ProfileVideoPlayer(source: source),
          ],
        ),
      ),
    );
  }
}

class ProfileVideoPlayer extends StatefulWidget {
  const ProfileVideoPlayer({super.key, required this.source});

  final String source;

  @override
  State<ProfileVideoPlayer> createState() => _ProfileVideoPlayerState();
}

class _ProfileVideoPlayerState extends State<ProfileVideoPlayer> {
  VideoPlayerController? _controller;
  late final Future<void> _initialize;
  Object? _sourceError;

  @override
  void initState() {
    super.initState();
    try {
      _controller = _controllerForSource(widget.source);
      _initialize = _controller!.initialize();
    } catch (error) {
      _sourceError = error;
      _initialize = Future<void>.value();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return FutureBuilder<void>(
      future: _initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final controller = _controller;
        final error = _sourceError ?? snapshot.error;
        if (error != null || controller == null) {
          return SizedBox(
            height: 160,
            child: Center(
              child: Text(
                l.couldNotOpenVideoIntroduction,
                textAlign: TextAlign.center,
                style: IthakiTheme.bodySmall.copyWith(
                  color: IthakiTheme.textSecondary,
                ),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: IthakiButton(
                controller.value.isPlaying ? l.pauseVideo : l.playVideo,
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  VideoPlayerController _controllerForSource(String source) {
    final uri = uriForResourceSource(source);
    if (uri == null) {
      throw ArgumentError('Video source is empty');
    }
    if (uri.isScheme('http') || uri.isScheme('https')) {
      return VideoPlayerController.networkUrl(uri);
    }
    return VideoPlayerController.file(File(uri.toFilePath()));
  }
}
