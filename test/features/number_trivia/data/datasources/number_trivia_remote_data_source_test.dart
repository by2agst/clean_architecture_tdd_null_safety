import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    final responseBody = fixture('trivia');
    const reponseCode = 200;
    final response = http.Response(responseBody, reponseCode);

    when(() => mockHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => response);
  }

  void setUpMockHttpClientFailure404() {
    const responseBody = 'Something went wrong';
    const reponseCode = 404;
    final response = http.Response(responseBody, reponseCode);

    when(() => mockHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => response);
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia')));

    test(
      'Should perform a GET request on a URL with number being the endpoint with aplication/json header',
      () {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        final uri = Uri.parse('http://numbersapi.com/$tNumber');
        final headers = {
          'Content-Type': 'application/json',
        };
        verify(() => mockHttpClient.get(uri, headers: headers));
      },
    );

    test(
      'Should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Should throw a server exception when the response code is 404 or any other failure code',
      () {
        // arrange
        setUpMockHttpClientFailure404();

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia')));

    test(
      'Should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        dataSource.getRandomNumberTrivia();

        // assert
        final uri = Uri.parse('$api/random');
        final header = {
          'Content-Type': 'application/json',
        };
        verify(() => mockHttpClient.get(uri, headers: header));
      },
    );

    test(
      'Should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getRandomNumberTrivia();

        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Should throw a server exception when the response code is 404 or any other failure code',
      () {
        // arrange
        setUpMockHttpClientFailure404();

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
