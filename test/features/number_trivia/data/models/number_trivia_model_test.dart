import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('Should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should return a valid model when the JSON number is an integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
    test('Should return a valid model when the JSON number is regarded as a double', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedMap = {
        "text": "Test text",
        "number": 1,
      };

      expect(result, expectedMap);
    });
  });
}
