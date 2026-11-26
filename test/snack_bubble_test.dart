import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snack_bubble/snack_bubble.dart';

void main() {
  group('SnackBubbleWidget', () {
    testWidgets('renders title, message and animated icon correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnackBubbleWidget(
              title: 'Success Title',
              message: 'Your item was saved successfully.',
              type: SnackBubbleType.success,
              variant: SnackBubbleVariant.glassmorphic,
            ),
          ),
        ),
      );

      expect(find.text('Success Title'), findsOneWidget);
      expect(find.text('Your item was saved successfully.'), findsOneWidget);
      expect(find.byType(AnimatedBubbleIcon), findsOneWidget);
    });

    testWidgets('renders simple static icon when iconStyle is simple', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnackBubbleWidget(
              title: 'Success Title',
              message: 'Your item was saved successfully.',
              type: SnackBubbleType.success,
              variant: SnackBubbleVariant.glassmorphic,
              iconStyle: SnackBubbleIconStyle.simple,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('renders avatar and online badge when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnackBubbleWidget(
              title: 'Sarah',
              message: 'Hello there',
              avatar: SnackBubbleAvatar(
                initials: 'SC',
                isOnline: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('SC'), findsOneWidget);
      expect(find.text('Sarah'), findsOneWidget);
    });

    testWidgets('renders action button and triggers callback', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SnackBubbleWidget(
              message: 'Action test',
              action: SnackBubbleAction(
                label: 'Undo',
                onPressed: () => actionTriggered = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Undo'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      expect(actionTriggered, isTrue);
    });
  });

  group('SnackBubble Static Controller', () {
    testWidgets('shows and hides bubble overlay', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  SnackBubble.show(
                    context,
                    title: 'Hello',
                    message: 'Floating notification',
                    type: SnackBubbleType.info,
                    variant: SnackBubbleVariant.neon,
                    duration: const Duration(seconds: 2),
                  );
                },
                child: const Text('Show Bubble'),
              ),
            ),
          ),
        ),
      );

      expect(SnackBubble.isVisible, isFalse);

      await tester.tap(find.text('Show Bubble'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(SnackBubble.isVisible, isTrue);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Floating notification'), findsOneWidget);

      SnackBubble.hide();
      await tester.pump();
      expect(SnackBubble.isVisible, isFalse);
    });
  });
}
