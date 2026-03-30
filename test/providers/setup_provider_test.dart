// test/providers/setup_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_ui/models/profile_models.dart';
import 'package:ithaki_ui/providers/setup_provider.dart';

void main() {
  // ─── setupProvider ────────────────────────────────────────────────────────

  group('setupProvider – initial state', () {
    test('all string fields start empty', () {
      final c = ProviderContainer.test();
      final s = c.read(setupProvider);
      expect(s.citizenshipCode, '');
      expect(s.citizenshipLabel, '');
      expect(s.residenceCode, '');
      expect(s.residenceLabel, '');
      expect(s.role, '');
      expect(s.relocation, '');
      expect(s.positionLevel, '');
      expect(s.salary, '');
      expect(s.paymentTerm, '');
    });

    test('all collection fields start empty', () {
      final c = ProviderContainer.test();
      final s = c.read(setupProvider);
      expect(s.jobInterests, isEmpty);
      expect(s.jobTypes, isEmpty);
      expect(s.workplaceFormats, isEmpty);
      expect(s.values, isEmpty);
      expect(s.communicationChannels, isEmpty);
    });

    test('boolean fields start false', () {
      final c = ProviderContainer.test();
      final s = c.read(setupProvider);
      expect(s.preferNotToSpecifySalary, false);
      expect(s.receiveTips, false);
    });
  });

  group('setupProvider – setLocation', () {
    test('setLocation updates all four location fields', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'ES',
            residenceLabel: 'Spain',
          );
      final s = c.read(setupProvider);
      expect(s.citizenshipCode, 'GR');
      expect(s.citizenshipLabel, 'Greece');
      expect(s.residenceCode, 'ES');
      expect(s.residenceLabel, 'Spain');
    });

    test('setLocation with optional role and relocation sets those too', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'GR',
            residenceLabel: 'Greece',
            role: 'Employed',
            relocation: 'Yes',
          );
      expect(c.read(setupProvider).role, 'Employed');
      expect(c.read(setupProvider).relocation, 'Yes');
    });

    test('setLocation without optional params preserves previous role', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'GR',
            residenceLabel: 'Greece',
            role: 'Employed',
          );
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'ES',
            citizenshipLabel: 'Spain',
            residenceCode: 'ES',
            residenceLabel: 'Spain',
            // role omitted
          );
      expect(c.read(setupProvider).role, 'Employed');
    });

    test('setLocation does not affect other state sections', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '1', title:'Software', category: ''),
      ]);
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'GR',
            residenceLabel: 'Greece',
          );
      expect(c.read(setupProvider).jobInterests.length, 1);
    });
  });

  group('setupProvider – setJobInterests', () {
    test('setJobInterests populates the list', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '1', title:'Software', category:'Dev'),
      ]);
      expect(c.read(setupProvider).jobInterests.length, 1);
      expect(c.read(setupProvider).jobInterests.first.title, 'Software');
    });

    test('setJobInterests replaces the previous list entirely', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '1', title:'Software', category: ''),
      ]);
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '2', title:'Design', category: ''),
        const JobInterest(id: '3', title:'Marketing', category: ''),
      ]);
      expect(c.read(setupProvider).jobInterests.length, 2);
      expect(c.read(setupProvider).jobInterests.first.title, 'Design');
    });

    test('setJobInterests with empty list clears interests', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '1', title:'Software', category: ''),
      ]);
      c.read(setupProvider.notifier).setJobInterests([]);
      expect(c.read(setupProvider).jobInterests, isEmpty);
    });
  });

  group('setupProvider – setPreferences', () {
    test('setPreferences updates all preference fields', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setPreferences(
            positionLevel: 'Senior',
            jobTypes: {'Full time', 'Part time'},
            workplaceFormats: {'Remote'},
            salary: '3000',
            paymentTerm: 'monthly',
            preferNotToSpecifySalary: false,
          );
      final s = c.read(setupProvider);
      expect(s.positionLevel, 'Senior');
      expect(s.jobTypes, containsAll(['Full time', 'Part time']));
      expect(s.workplaceFormats, contains('Remote'));
      expect(s.salary, '3000');
      expect(s.paymentTerm, 'monthly');
      expect(s.preferNotToSpecifySalary, false);
    });

    test('setPreferences can set preferNotToSpecifySalary to true', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier)
          .setPreferences(preferNotToSpecifySalary: true);
      expect(c.read(setupProvider).preferNotToSpecifySalary, true);
    });

    test('partial setPreferences preserves fields not passed', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setPreferences(positionLevel: 'Junior');
      c.read(setupProvider.notifier).setPreferences(salary: '2000');
      expect(c.read(setupProvider).positionLevel, 'Junior');
      expect(c.read(setupProvider).salary, '2000');
    });
  });

  group('setupProvider – setValues', () {
    test('setValues populates the values set', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setValues({'Innovation', 'Integrity'});
      expect(c.read(setupProvider).values,
          containsAll(['Innovation', 'Integrity']));
    });

    test('setValues replaces previous set', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setValues({'A', 'B'});
      c.read(setupProvider.notifier).setValues({'C'});
      expect(c.read(setupProvider).values, {'C'});
    });

    test('setValues with empty set clears values', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setValues({'Innovation'});
      c.read(setupProvider.notifier).setValues({});
      expect(c.read(setupProvider).values, isEmpty);
    });
  });

  group('setupProvider – setCommunication', () {
    test('setCommunication sets channels and receiveTips', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setCommunication({'email', 'sms'}, true);
      expect(c.read(setupProvider).communicationChannels,
          containsAll(['email', 'sms']));
      expect(c.read(setupProvider).receiveTips, true);
    });

    test('setCommunication with receiveTips false', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setCommunication({'push'}, false);
      expect(c.read(setupProvider).receiveTips, false);
    });

    test('setCommunication replaces previous channels', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setCommunication({'email'}, false);
      c.read(setupProvider.notifier).setCommunication({'sms', 'push'}, true);
      expect(c.read(setupProvider).communicationChannels,
          isNot(contains('email')));
      expect(c.read(setupProvider).communicationChannels,
          containsAll(['sms', 'push']));
    });
  });

  group('setupProvider – reset', () {
    test('reset clears all fields back to initial values', () {
      final c = ProviderContainer.test();
      c.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'GR',
            residenceLabel: 'Greece',
            role: 'Employed',
          );
      c.read(setupProvider.notifier).setJobInterests([
        const JobInterest(id: '1', title: 'Dev', category: ''),
      ]);
      c.read(setupProvider.notifier).setValues({'Innovation'});
      c.read(setupProvider.notifier).setCommunication({'email'}, true);
      c.read(setupProvider.notifier).reset();
      final s = c.read(setupProvider);
      expect(s.citizenshipCode, '');
      expect(s.role, '');
      expect(s.jobInterests, isEmpty);
      expect(s.values, isEmpty);
      expect(s.communicationChannels, isEmpty);
      expect(s.receiveTips, false);
    });
  });

  group('setupProvider – isolation', () {
    test('two containers are fully isolated from each other', () {
      final c1 = ProviderContainer.test();
      final c2 = ProviderContainer.test();
      c1.read(setupProvider.notifier).setLocation(
            citizenshipCode: 'GR',
            citizenshipLabel: 'Greece',
            residenceCode: 'GR',
            residenceLabel: 'Greece',
          );
      expect(c2.read(setupProvider).citizenshipCode, '');
    });
  });
}
