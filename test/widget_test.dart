import 'package:flutter_test/flutter_test.dart';
import 'package:edu_app/main.dart';

void main() {
  testWidgets('App root loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduApp());
  });
}
