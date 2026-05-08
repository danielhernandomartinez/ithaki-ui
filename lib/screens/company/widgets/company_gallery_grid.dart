import 'package:flutter/material.dart';

import 'company_visual_placeholder.dart';

class CompanyGalleryGrid extends StatelessWidget {
  const CompanyGalleryGrid({super.key, required this.imageAssets});

  final List<String> imageAssets;

  @override
  Widget build(BuildContext context) {
    if (imageAssets.length < 5) {
      return const _CompanyGalleryPlaceholderGrid();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[0],
                height: 154,
                borderRadius: 18,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[1],
                height: 154,
                borderRadius: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[2],
                height: 90,
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[3],
                height: 90,
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Stack(
                children: [
                  _CompanyImageTile(
                    imageAsset: imageAssets[4],
                    height: 90,
                    borderRadius: 14,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          '+10',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CompanyImageTile extends StatelessWidget {
  const _CompanyImageTile({
    required this.imageAsset,
    required this.height,
    required this.borderRadius,
  });

  final String imageAsset;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageAsset.isEmpty) {
      return CompanyVisualPlaceholder(
        title: 'Workspace placeholder',
        subtitle: 'Replace with approved media later.',
        height: height,
        iconName: 'home',
        borderRadius: borderRadius,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        imageAsset,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CompanyGalleryPlaceholderGrid extends StatelessWidget {
  const _CompanyGalleryPlaceholderGrid();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 4);
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Office life',
                subtitle: 'Gallery placeholder',
                height: 154,
                iconName: 'team',
                borderRadius: 18,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Team moments',
                subtitle: 'Gallery placeholder',
                height: 154,
                iconName: 'learning-hub',
                borderRadius: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Projects',
                subtitle: '',
                height: 90,
                iconName: 'assessment',
                borderRadius: 14,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Events',
                subtitle: '',
                height: 90,
                iconName: 'calendar',
                borderRadius: 14,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'More',
                subtitle: '+10',
                height: 90,
                iconName: 'blog',
                borderRadius: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
