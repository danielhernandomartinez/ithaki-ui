import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class JobDetailShareOption extends StatelessWidget {
  final String icon;
  final String label;
  const JobDetailShareOption(
      {super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
      const SizedBox(width: 12),
      Text(label,
          style: const TextStyle(fontFamily: 'Noto Sans', fontSize: 15)),
    ]);
  }
}

class JobDetailCell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool bold;
  final bool wide;
  const JobDetailCell({
    super.key,
    required this.label,
    this.icon,
    required this.value,
    this.bold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 155,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.softGraphite,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 5),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (icon != null) ...[
            IthakiIcon(icon!, size: 16, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: bold ? 17 : 14,
                height: 1.35,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

class JobDetailSkillChip extends StatelessWidget {
  final String label;
  const JobDetailSkillChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text(
          '✓',
          style: TextStyle(
            fontSize: 11,
            color: IthakiTheme.softGraphite,
            height: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            height: 1.1,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }
}

class JobDetailSectionTitle extends StatelessWidget {
  final String text;
  const JobDetailSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: IthakiTheme.textPrimary,
        ));
  }
}

class JobDetailSection extends StatelessWidget {
  final String title;
  final String body;
  const JobDetailSection({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      JobDetailSectionTitle(title),
      const SizedBox(height: 8),
      Text(body,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.textPrimary,
            height: 1.5,
          )),
    ]);
  }
}

class JobTextSection extends StatelessWidget {
  final String title;
  final String body;
  const JobTextSection({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: jobSectionTitleStyle),
      const SizedBox(height: 7),
      Text(body, style: jobSectionBodyStyle),
    ]);
  }
}

class JobBulletSection extends StatelessWidget {
  final String title;
  final List<String> items;
  const JobBulletSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: jobSectionTitleStyle),
      const SizedBox(height: 9),
      ...items.where((item) => item.trim().isNotEmpty).map(JobBullet.new),
    ]);
  }
}

class JobBullet extends StatelessWidget {
  final String text;
  const JobBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7, right: 8),
          decoration: const BoxDecoration(
            color: IthakiTheme.borderLight,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: Text(text, style: jobSectionBodyStyle)),
      ]),
    );
  }
}

class JobDetailBullet extends StatelessWidget {
  final String text;
  const JobDetailBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('• ',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
              )),
        ),
      ]),
    );
  }
}

List<String> splitJobBullets(String value) {
  final lines = value
      .split(RegExp(r'\r?\n|•|- '))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  return lines.length > 1 ? lines : [value.trim()];
}

const jobSectionTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: IthakiTheme.textPrimary,
);

const jobSectionBodyStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  height: 1.48,
  color: IthakiTheme.textPrimary,
);
