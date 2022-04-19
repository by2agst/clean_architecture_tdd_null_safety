import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

const api = 'http://numbersapi.com';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return _getTriviFromUrl('$api/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviFromUrl('$api/random');
  }

  Future<NumberTriviaModel> _getTriviFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return NumberTriviaModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }
}
