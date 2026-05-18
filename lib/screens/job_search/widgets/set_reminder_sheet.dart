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
            const _SheetHandle(),
            const SizedBox(height: 16),
            _SheetTitleRow(onClose: () => Navigator.pop(context)),
            const SizedBox(height: 16),
            _ReminderJobHeader(
              jobTitle: widget.jobTitle,
              companyName: widget.companyName,
              salary: widget.salary,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: IthakiTheme.borderLight),
            const SizedBox(height: 12),
            if (widget.deadlineDate.isNotEmpty) ...[
              _DeadlineBanner(date: widget.deadlineDate),
              const SizedBox(height: 20),
            ],
            _WhenSection(
              deadlineDate: widget.deadlineDate,
              selected: _when,
              onChanged: (v) => setState(() => _when = v),
              dateController: _dateController,
              time: _time,
              onTimeChanged: (v) => setState(() => _time = v),
            ),
            const SizedBox(height: 20),
            _NotifySection(
              byEmail: _byEmail,
              bySms: _bySms,
              onEmailToggle: () => setState(() => _byEmail = !_byEmail),
              onSmsToggle: () => setState(() => _bySms = !_bySms),
              userEmail: widget.userEmail,
              userPhone: widget.userPhone,
              canSubmit: _byEmail || _bySms,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Static sub-widgets ───────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: IthakiTheme.borderLight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetTitleRow extends StatelessWidget {
  final VoidCallback onClose;
  const _SheetTitleRow({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.setReminderTitle,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: const IthakiIcon('delete', size: 22, color: IthakiTheme.softGraphite),
        ),
      ],
    );
  }
}

class _ReminderJobHeader extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String salary;
  const _ReminderJobHeader({
    required this.jobTitle,
    required this.companyName,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          jobTitle,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              companyName,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                color: IthakiTheme.softGraphite,
              ),
            ),
            Text(
              salary,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeadlineBanner extends StatelessWidget {
  final String date;
  const _DeadlineBanner({required this.date});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
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
              const IthakiIcon('calendar', size: 18, color: IthakiTheme.primaryPurple),
              const SizedBox(width: 8),
              Text(
                l.applicationOpenTill,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── When section ─────────────────────────────────────────────────────────────

class _WhenSection extends StatelessWidget {
  final String deadlineDate;
  final _ReminderWhen selected;
  final ValueChanged<_ReminderWhen> onChanged;
  final TextEditingController dateController;
  final String time;
  final ValueChanged<String> onTimeChanged;

  const _WhenSection({
    required this.deadlineDate,
    required this.selected,
    required this.onChanged,
    required this.dateController,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.whenShouldRemind,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _OptionBox(
          selected: selected == _ReminderWhen.tomorrow,
          title: l.reminderTomorrow,
          subtitle: l.reminderTomorrowSub,
          onTap: () => onChanged(_ReminderWhen.tomorrow),
        ),
        const SizedBox(height: 8),
        _OptionBox(
          selected: selected == _ReminderWhen.inOneWeek,
          title: l.reminderOneWeek,
          subtitle: l.reminderOneWeekSub,
          onTap: () => onChanged(_ReminderWhen.inOneWeek),
        ),
        if (deadlineDate.isNotEmpty) ...[
          const SizedBox(height: 8),
          _OptionBox(
            selected: selected == _ReminderWhen.oneDayBefore,
            title: l.reminderOneDayBefore,
            subtitle: l.reminderOneDayBeforeSub,
            onTap: () => onChanged(_ReminderWhen.oneDayBefore),
          ),
        ],
        const SizedBox(height: 8),
        _OptionBox(
          selected: selected == _ReminderWhen.custom,
          title: l.reminderCustomDate,
          subtitle: l.reminderCustomDateSub,
          onTap: () => onChanged(_ReminderWhen.custom),
        ),
        if (selected == _ReminderWhen.custom) ...[
          const SizedBox(height: 12),
          Text(
            l.selectDateLabel,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: dateController,
            decoration: InputDecoration(
              hintText: l.ddMmYyyyHint,
              hintStyle: const TextStyle(color: IthakiTheme.textSecondary),
              suffixIcon: const IthakiIcon('calendar', size: 20, color: IthakiTheme.softGraphite),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.selectTimeLabel,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: time,
            decoration: InputDecoration(
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: IthakiIcon('clock', size: 20, color: IthakiTheme.softGraphite),
              ),
              prefixIconConstraints: const BoxConstraints(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: IthakiTheme.borderLight),
              ),
            ),
            items: ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
                    '14:00', '15:00', '16:00', '17:00', '18:00', '20:00']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => onTimeChanged(v!),
          ),
        ],
      ],
    );
  }
}

// ─── Notify section ───────────────────────────────────────────────────────────

class _NotifySection extends StatelessWidget {
  final bool byEmail;
  final bool bySms;
  final VoidCallback onEmailToggle;
  final VoidCallback onSmsToggle;
  final String userEmail;
  final String userPhone;
  final bool canSubmit;

  const _NotifySection({
    required this.byEmail,
    required this.bySms,
    required this.onEmailToggle,
    required this.onSmsToggle,
    required this.userEmail,
    required this.userPhone,
    required this.canSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final hasContact = userEmail.isNotEmpty || userPhone.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.reminderChoiceTitle,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (hasContact) ...[
          if (userEmail.isNotEmpty) ...[
            _OptionBox(
              selected: byEmail,
              title: l.email,
              subtitle: l.reminderViaContactSub(userEmail),
              onTap: onEmailToggle,
            ),
            const SizedBox(height: 8),
          ],
          if (userPhone.isNotEmpty) ...[
            _OptionBox(
              selected: bySms,
              title: l.reminderViaSmsWhatsapp,
              subtitle: l.reminderViaContactSub(userPhone),
              onTap: onSmsToggle,
            ),
            const SizedBox(height: 8),
          ],
        ] else ...[
          _OptionBox(
            selected: byEmail,
            title: l.email,
            subtitle: l.reminderViaEmail,
            onTap: onEmailToggle,
          ),
          const SizedBox(height: 8),
          _OptionBox(
            selected: bySms,
            title: l.reminderViaSmsWhatsapp,
            subtitle: l.reminderViaSmsWhatsappGeneric,
            onTap: onSmsToggle,
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        IthakiButton(
          l.setReminderButton,
          onPressed: canSubmit ? () => Navigator.pop(context, true) : null,
        ),
      ],
    );
  }
}

// ─── Option box ───────────────────────────────────────────────────────────────

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
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                color: IthakiTheme.softGraphite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
