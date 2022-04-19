import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  late MockNumberTriviaRepository? mockNumberTriviaRepository;
  late GetRandomNumberTrivia? usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  test(
    'Should get trivia from the repository',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository!.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await usecase!(NoParams());

      // assert
      expect(result, equals(const Right(tNumberTrivia)));
      verify(() => mockNumberTriviaRepository!.getRandomNumberTrivia());
    },
  );
}
