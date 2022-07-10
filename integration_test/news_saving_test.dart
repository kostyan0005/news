import 'package:flutter_test/flutter_test.dart';

Future<void> testNewsSavingLogic(WidgetTester tester) async {
  // todo
  // news list is loaded, you save the first piece, then go to the next tab,
  // save another piece (also make sure that it's different from the previous
  // saved), then go to saved news tab, check that there are two
  // saved news pieces exactly equal to the ones you saved, remove the piece
  // from saved, check that it's removed and now 1 piece is left in saved,
  // check that when you open it, it's shown as saved (you see removed from
  // saved in options), then remove it from saved from it's page, then go
  // and check that 0 saved are left
}
