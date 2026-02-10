import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_vibration/demo_vibration.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('vibration');
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) {
      log.add(methodCall);

      return null;
    });
  });

  tearDown(() {
    log.clear();
  });

  group('hasVibrator', () {
    test(
      'returns false',
      () async {
        bool? hasVibrator = await DemoVibration.hasVibrator();

        expect(
          hasVibrator,
          equals(false),
        );
      },
    );

    test('throws PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'error');
      });

      final hasVibrator = await DemoVibration.hasVibrator();

      throwsA(isA<PlatformException>());
      expect(hasVibrator, isFalse);
    });

    test('throws UnsupportedError', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw UnsupportedError('error');
      });

      final hasVibrator = await DemoVibration.hasVibrator();

      throwsA(isA<UnsupportedError>());
      expect(hasVibrator, isFalse);
    });
  });

  group('hasAmplitudeControl', () {
    test(
      'returns false',
      () async {
        bool? hasAmplitudeControl = await DemoVibration.hasAmplitudeControl();

        expect(hasAmplitudeControl, isFalse);
      },
    );

    test('throws PlatformException', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(code: 'error');
      });

      final hasAmplitudeControl = await DemoVibration.hasAmplitudeControl();

      throwsA(isA<PlatformException>());
      expect(hasAmplitudeControl, isFalse);
    });

    test('throws UnsupportedError', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw UnsupportedError('error');
      });

      final hasAmplitudeControl = await DemoVibration.hasAmplitudeControl();

      throwsA(isA<UnsupportedError>());
      expect(hasAmplitudeControl, isFalse);
    });
  });

  test(
    'vibrate with duration',
    () async {
      await DemoVibration.vibrate(duration: 100);

      expect(
        log,
        <Matcher>[
          isMethodCall('vibrate', arguments: <String, Object>{
            'duration': 100,
            'pattern': [],
            'repeat': -1,
            'amplitude': -1,
            'intensities': [],
            'sharpness': 0.5,
          })
        ],
      );
    },
  );

  test(
    'vibrate with pattern',
    () async {
      await DemoVibration.vibrate(pattern: [100, 200, 400], repeat: 1);

      expect(
        log,
        <Matcher>[
          isMethodCall('vibrate', arguments: <String, Object>{
            'duration': 500,
            'pattern': [100, 200, 400],
            'repeat': 1,
            'amplitude': -1,
            'intensities': [],
            'sharpness': 0.5,
          })
        ],
      );
    },
  );

  test(
    'cancel vibration',
    () async {
      await DemoVibration.cancel();

      expect(
        log,
        <Matcher>[isMethodCall('cancel', arguments: null)],
      );
    },
  );
}
