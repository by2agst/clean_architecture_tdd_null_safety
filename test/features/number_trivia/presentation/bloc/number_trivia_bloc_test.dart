import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/utilities/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  const tParsedNumber = 1;
  const tStringNumber = '1';
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUpAll(() {
    registerFallbackValue(const Params(number: tParsedNumber));
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia!,
      getRandomNumberTrivia: mockGetRandomNumberTrivia!,
      inputConverter: mockInputConverter!,
    );
  });

  void setUpMockInputConverterSuccess() {
    when(() => mockInputConverter!.stringToUnsignedInteger(any()))
        .thenReturn(const Right(tParsedNumber));
  }

  void setUpMockGetConcreteNumberTriviaSuccess() {
    when(() => mockGetConcreteNumberTrivia!(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));
  }

  void setUpMockGetRandomNumberTriviaSuccess() {
    when(() => mockGetRandomNumberTrivia!(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));
  }

  test('InitialState Should be empty', () {
    expect(bloc!.state, equals(InitialNumberTriviaState()));
  });

  group('GetTriviaForConcreteNumber', () {
    test(
      'Should call the InputConverter to validate and convert the number to an unsigned integer',
      () async {
        // arrange
        when(() => mockInputConverter!.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tParsedNumber));
        when(() => mockGetConcreteNumberTrivia!(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));

        await untilCalled(
            () => mockInputConverter!.stringToUnsignedInteger(any()));

        // assert
        verify(
            () => mockInputConverter!.stringToUnsignedInteger(tStringNumber));
      },
    );

    test(
      'Should emit [ErrorNumberTriviaState] when the input is invalid',
      () {
        // arrange
        when(() => mockInputConverter!.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

        // assert
        expectLater(
          bloc!.stream,
          emitsInOrder([
            const ErrorNumberTriviaState(message: invalidInputFailureMessage),
          ]),
        );

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));
      },
    );

    test('Should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      // act
      bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));
      await untilCalled(() => mockGetConcreteNumberTrivia!(any()));

      // // assert
      verify(
        () => mockGetConcreteNumberTrivia!(const Params(number: tParsedNumber)),
      );
    });

    test(
      'Should emit [LoadingNumberTriviaState, LoadedNumberTriviaState] states when data is gotten successfully',
      () {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const LoadedNumberTriviaState(trivia: tNumberTrivia),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));
      },
    );

    test(
      'Should emit [LoadingNumberTriviaState, ErrorNumberTriviaState] states when data is gotten successfully',
      () {
        // arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia!(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const ErrorNumberTriviaState(message: serverFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));
      },
    );
    test(
      'Should emit [LoadingNumberTriviaState, ErrorNumberTriviaState] with a propper message for the error when getting data fails',
      () {
        // arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia!(any()))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const ErrorNumberTriviaState(message: cacheFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(const GetTriviaForConcreteNumber(tStringNumber));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    test('Should get data from the random use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      setUpMockGetRandomNumberTriviaSuccess();

      // act
      bloc!.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia!(NoParams()));

      // // assert
      verify(
        () => mockGetRandomNumberTrivia!(NoParams()),
      );
    });

    test(
      'Should emit [LoadingNumberTriviaState, LoadedNumberTriviaState] states when data is gotten successfully',
      () {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetRandomNumberTriviaSuccess();

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const LoadedNumberTriviaState(trivia: tNumberTrivia),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'Should emit [LoadingNumberTriviaState, ErrorNumberTriviaState] states when data is gotten successfully',
      () {
        // arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetRandomNumberTrivia!(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const ErrorNumberTriviaState(message: serverFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );
    test(
      'Should emit [LoadingNumberTriviaState, ErrorNumberTriviaState] with a propper message for the error when getting data fails',
      () {
        // arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetRandomNumberTrivia!(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          LoadingNumberTriviaState(),
          const ErrorNumberTriviaState(message: cacheFailureMessage),
        ];

        expectLater(bloc!.stream, emitsInOrder(expected));

        // act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );
  });
}
