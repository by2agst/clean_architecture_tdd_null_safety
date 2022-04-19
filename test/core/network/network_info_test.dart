import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
  });

  group('isConnected', () {
    test(
      'Should forward the call to DataConnectionChecker.hasConnection',
      () {
        // arrange
        final tHasConnectionFuture = Future.value(true);

        when(() => mockInternetConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);

        // act
        final result = mockInternetConnectionChecker.hasConnection;

        // assert
        verify(() => mockInternetConnectionChecker.hasConnection);
        expect(result, equals(tHasConnectionFuture));
      },
    );
  });
}
