import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';

enum _ReminderWhen { tomorrow, inOneWeek, oneDayBefore, custom }

class SetReminderSheet extends StatefulWidget {
  final String jobTitle;
  final String salary;
  final String companyName;
  final String deadlineDate;
  final String userEmail;
  final String userPhone;

  const SetReminderSheet({
    super.key,
    required this.jobTitle,
    required this.salary,
    required this.companyName,
    required this.deadlineDate,
    this.userEmail = '',
    this.userPhone = '',
  });

  @override
  State<SetReminderSheet> createState() => _SetReminderSheetState();
}

class _SetReminderSheetState extends State<SetReminderSheet> {
  _ReminderWhen _when = _ReminderWhen.tomorrow;
  bool _byEmail = true;
  bool _bySms = false;
  final _dateController = TextEditingController();
  String _time = '12:00';

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: IthakiTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title row
            Row(
              children: [
                Expanded(
                  child: Text(l.setReminderTitle,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      )),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const IthakiIcon('delete',
                      size: 22, color: IthakiTheme.softGraphite),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Job header
            Text(widget.jobTitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.companyName,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      color: IthakiTheme.softGraphite,
                    )),
                Text(widget.salary,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      color: IthakiTheme.textPrimary,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: IthakiTheme.borderLight),
            const SizedBox(height: 12),
            // Application deadline
            if (widget.deadlineDate.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: IthakiTheme.accentPurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const IthakiIcon('calendar',
                            size: 18, color: IthakiTheme.primaryPurple),
                        const SizedBox(width: 8),
                        Text(l.applicationOpenTill,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans',
                              fontSize: 14,
                              color: IthakiTheme.textPrimary,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: IthakiTheme.backgroundWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(widget.deadlineDate,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // When section
            Text(l.whenShouldRemind,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            const SizedBox(height: 12),
            _OptionBox(
              selected: _when == _ReminderWhen.tomorrow,
              title: l.reminderTomorrow,
              subtitle: l.reminderTomorrowSub,
              onTap: () => setState(() => _when = _ReminderWhen.tomorrow),
            ),
            const SizedBox(height: 8),
            _OptionBox(
              selected: _when == _ReminderWhen.inOneWeek,
              title: l.reminderOneWeek,
              subtitle: l.reminderOneWeekSub,
              onTap: () => setState(() => _when = _ReminderWhen.inOneWeek),
            ),
            if (widget.deadlineDate.isNotEmpty) ...[
              const SizedBox(height: 8),
              _OptionBox(
                selected: _when == _ReminderWhen.oneDayBefore,
                title: l.reminderOneDayBefore,
                subtitle: l.reminderOneDayBeforeSub,
                onTap: () => setState(() => _when = _ReminderWhen.oneDayBefore),
              ),
            ],
            const SizedBox(height: 8),
            _OptionBox(
              selected: _when == _ReminderWhen.custom,
              title: l.reminderCustomDate,
              subtitle: l.reminderCustomDateSub,
              onTap: () => setState(() => _when = _ReminderWhen.custom),
            ),
            if (_when == _ReminderWhen.custom) ...[
              const SizedBox(height: 12),
              Text(l.selectDateLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.textSecondary,
                  )),
              const SizedBox(height: 6),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: l.ddMmYyyyHint,
                  hintStyle: const TextStyle(color: IthakiTheme.textSecondary),
                  suffixIcon: const IthakiIcon('calendar',
                      size: 20, color: IthakiTheme.softGraphite),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(l.selectTimeLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.textSecondary,
                  )),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _time,
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 12, right: 8),
                    child: IthakiIcon('clock',
                        size: 20, color: IthakiTheme.softGraphite),
                  ),
                  prefixIconConstraints: const BoxConstraints(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                ),
                items: [
                  '08:00',
                  '09:00',
                  '10:00',
                  '11:00',
                  '12:00',
                  '13:00',
                  '14:00',
                  '15:00',
                  '16:00',
                  '17:00',
                  '18:00',
                  '20:00'
                ]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _time = v!),
              ),
            ],
            const SizedBox(height: 20),
            // How section
            Text(l.reminderChoiceTitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            const SizedBox(height: 12),
            if (widget.userEmail.isNotEmpty) ...[
              _OptionBox(
                selected: _byEmail,
                title: l.email,
                subtitle: l.reminderViaContactSub(widget.userEmail),
                onTap: () => setState(() => _byEmail = !_byEmail),
              ),
              const SizedBox(height: 8),
            ],
            if (widget.userPhone.isNotEmpty) ...[
              _OptionBox(
                selected: _bySms,
                title: l.reminderViaSmsWhatsapp,
                subtitle: l.reminderViaContactSub(widget.userPhone),
                onTap: () => setState(() => _bySms = !_bySms),
              ),
              const SizedBox(height: 8),
            ],
            if (widget.userEmail.isEmpty && widget.userPhone.isEmpty) ...[
              _OptionBox(
                selected: _byEmail,
                title: l.email,
                subtitle: l.reminderViaEmail,
                onTap: () => setState(() => _byEmail = !_byEmail),
              ),
              const SizedBox(height: 8),
              _OptionBox(
                selected: _bySms,
                title: l.reminderViaSmsWhatsapp,
                subtitle: l.reminderViaSmsWhatsappGeneric,
                onTap: () => setState(() => _bySms = !_bySms),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            IthakiButton(
              l.setReminderButton,
              onPressed: (_byEmail || _bySms)
                  ? () => Navigator.pop(context, true)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionBox extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionBox({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: IthakiTheme.primaryPurple, width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ],
        ),
      ),
    );
  }
}
