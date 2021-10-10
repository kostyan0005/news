import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomBarIndexProvider =
    StateNotifierProvider<BottomBarIndexNotifier, int>(
        (ref) => BottomBarIndexNotifier());

class BottomBarIndexNotifier extends StateNotifier<int> {
  BottomBarIndexNotifier() : super(0);

  void changeIndex(int tabIndex) => state = tabIndex;
}
