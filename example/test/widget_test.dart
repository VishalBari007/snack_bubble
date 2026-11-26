import 'package:flutter_test/flutter_test.dart';
import 'package:snack_bubble_example/main.dart';

void main() {
  testWidgets('Renders SnackBubble home screen', (tester) async {
    await tester.pumpWidget(const SnackBubbleApp());
    expect(find.text('SnackBubble'), findsOneWidget);
    expect(find.text('INTERACTIVE PRESETS'), findsOneWidget);
  });
}
