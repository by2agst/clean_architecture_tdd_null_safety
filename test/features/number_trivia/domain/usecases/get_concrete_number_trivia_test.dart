import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  const int tNumber = 1;
  const NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  late MockNumberTriviaRepository? mockNumberTriviaRepository;
  late GetConcreteNumberTrivia? usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  test(
    'Should get trivia for the number from the repositories',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository!.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await usecase!(const Params(number: tNumber));

      // assert
      expect(result, equals(const Right(tNumberTrivia)));
      verify(() => mockNumberTriviaRepository!.getConcreteNumberTrivia(1));
    },
  );
}
