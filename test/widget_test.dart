import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:daydump/main.dart';
import 'package:daydump/state/app_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const DayDumpApp(),
      ),
    );
    expect(find.byType(DayDumpApp), findsOneWidget);
  });
}
