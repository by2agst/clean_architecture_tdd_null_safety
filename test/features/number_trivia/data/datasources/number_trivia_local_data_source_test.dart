import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharePreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharePreferences mockSharePreferences;

  setUp(() {
    mockSharePreferences = MockSharePreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharePreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached')));
    test(
      'Should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(() => mockSharePreferences.getString(any()))
            .thenReturn(fixture('trivia_cached'));

        // act
        final result = await dataSource.getLastNumberTrivia();

        // assert
        verify(() => mockSharePreferences.getString(cachedNumberTrivia));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(() => mockSharePreferences.getString(any())).thenReturn(null);

        // act
        final call = dataSource.getLastNumberTrivia;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'test trivia',
    );

    test(
      'Should call sharedPrefences to cache the data',
      () {
        // arrange
        when(() => mockSharePreferences.setString(any(), any()))
            .thenAnswer((_) async => true);

        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);

        // assert
        final expecteJsonSring = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharePreferences.setString(
              cachedNumberTrivia,
              expecteJsonSring,
            ));
      },
    );
  });
}
