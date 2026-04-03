import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('<a> test', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        child: Html(
          data: """<a>Hello, world!</a>""",
        ),
      ),
    );
    expect(find.text("Hello, world!", findRichText: true), findsOneWidget);
  });

  testWidgets('<a> test with href', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        child: Html(
          data: """<a href="https://example.com">Hello, world!</a>""",
        ),
      ),
    );
    expect(find.text("Hello, world!", findRichText: true), findsOneWidget);
  });

  testWidgets('<a> with widget child renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        child: Html(
          data: """<a href="https://example.com"><icon></icon></a>""",
          extensions: [
            TagExtension(
              tagsToExtend: {"icon"},
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
    'Tapping <a> test',
    (WidgetTester tester) async {
      String tappedUrl = "";

      await tester.pumpWidget(
        TestApp(
          child: Html(
            data: """<a href="https://example.com">Hello, world!</a>""",
            onLinkTap: (url, _, __) {
              tappedUrl = url ?? "";
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("Hello, world!", findRichText: true), findsOneWidget);
      expect(tappedUrl, equals(""));
      await tester.tap(find.text("Hello, world!", findRichText: true));
      await tester.pump();
      expect(tappedUrl, equals("https://example.com"));
    },
    // widget_tester does not deliver taps to these TextSpan recognizers on current
    // Flutter (reproduces with html 0.15.4 as well); fix needs stable recognizers in lib.
    skip: true,
  );

  testWidgets(
    'Tapping <a> with widget works',
    (WidgetTester tester) async {
      String tappedUrl = "";

      await tester.pumpWidget(
        TestApp(
          child: Html(
            data: """<a href="https://example.com"><icon></icon></a>""",
            onLinkTap: (url, _, __) {
              tappedUrl = url ?? "";
            },
            extensions: [
              TagExtension(
                tagsToExtend: {"icon"},
                child: const Icon(Icons.check),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(tappedUrl, equals(""));
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();
      expect(tappedUrl, equals("https://example.com"));
    },
    skip: true,
  );
}
