import 'package:journal/journal.dart';

const _victims = ['Nahdar Vebb', 'Ur-Sema Du', 'Daakman Barrek', "Sha'a Gi", 'Tarr Seirr'];

void _useBlaster() => throw Exception('blasters are barbaric');

/// Runs example scenario.
Future<void> run() async {
  const journal = Journal('encounter');

  final context = Context.debug('participants', {
    'general': 'Kenobi'.toJournal,
    'opponent': 'Grievous'.toJournal,
  });

  await journal.withContext(context, (journal) async {
    journal.info('Hello there!', values: {'bold': true.toJournal, 'style': 'impeccable'.toJournal});

    await Future.delayed(const Duration(seconds: 1), () async {
      journal.warn('You fool!', values: {'sabers': _victims.map(Value.string).toJournal});

      await Future.delayed(const Duration(seconds: 1), () async {
        journal.trace('Some time later...');

        await Future.delayed(const Duration(seconds: 1), () {
          try {
            _useBlaster();
          } on Exception catch (ex, trace) {
            journal.error(
              'So uncivilized.',
              values: {'error': ex.toString().toJournal},
              trace: trace,
            );
          }
        });
      });
    });
  });
}
