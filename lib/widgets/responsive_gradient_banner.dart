import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class ResponsiveGradientBanner extends StatelessWidget {
  const ResponsiveGradientBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onButtonPressed,
    this.backgroundImage,
    this.onDismiss,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final Widget buttonIcon;
  final VoidCallback onButtonPressed;
  final DecorationImage? backgroundImage;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.primaryPurple,
          image: backgroundImage,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: IthakiTheme.sectionTitle.copyWith(
                      color: IthakiTheme.backgroundWhite,
                      height: 1.18,
                    ),
                  ),
                ),
                if (onDismiss != null) ...[
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    label: MaterialLocalizations.of(context).closeButtonTooltip,
                    child: InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        child: Text(
                          '×',
                          style: IthakiTheme.bodyRegular.copyWith(
                            color: IthakiTheme.backgroundWhite,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: IthakiTheme.bodySmall.copyWith(
                color: IthakiTheme.backgroundWhite.withValues(alpha: 0.78),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onButtonPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: IthakiTheme.backgroundWhite,
                  backgroundColor:
                      IthakiTheme.backgroundWhite.withValues(alpha: 0.2),
                  side: const BorderSide(color: IthakiTheme.backgroundWhite),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonIcon,
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        buttonLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: IthakiTheme.bodyRegular.copyWith(
                          color: IthakiTheme.backgroundWhite,
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
