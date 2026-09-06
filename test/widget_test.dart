import 'package:flutter_test/flutter_test.dart';
import 'package:testappthree/main.dart';

void main() {
  testWidgets('BingoApp loads and renders title and board', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BingoApp());

    // Verify main components exist
    expect(find.text('BINGO'), findsOneWidget);
    expect(find.text('FREE'), findsOneWidget);
    expect(find.text('Call Next'), findsOneWidget);
    expect(find.text('CALLED NUMBERS HISTORY'), findsOneWidget);
  });
}
