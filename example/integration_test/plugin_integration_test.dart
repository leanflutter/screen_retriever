// Runs against the real displays, so it needs a desktop: flutter test
// integration_test -d macos (or linux, windows).
// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:screen_retriever/legacy.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the primary display is among all displays', (tester) async {
    final primary = await screenRetriever.getPrimaryDisplay();
    final all = await screenRetriever.getAllDisplays();
    expect(all.map((display) => display.id), contains(primary.id));
    expect(primary.size.width, greaterThan(0));
    expect(primary.visibleSize!.height, lessThanOrEqualTo(primary.size.height));
  });

  testWidgets('getCursorScreenPoint answers', (tester) async {
    final Offset point = await screenRetriever.getCursorScreenPoint();
    expect(point.dx.isFinite && point.dy.isFinite, isTrue);
  });
}
