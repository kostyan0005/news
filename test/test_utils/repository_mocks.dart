import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

class MockNewsSearchRepository extends Mock implements NewsSearchRepository {}

class MockSubscriptionsRepository extends Mock
    implements SubscriptionsRepository {}

class MockSavedNewsRepository extends Mock implements SavedNewsRepository {}

class MockHistoryRepository extends Mock implements HistoryRepository {}

class MockUserSettingsRepository extends Mock
    implements UserSettingsRepository {}
