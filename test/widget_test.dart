import 'package:flutter_test/flutter_test.dart';
import 'package:chatbill/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChatBillApp());
    expect(find.text('Chat Bill'), findsOneWidget);
  });
}
