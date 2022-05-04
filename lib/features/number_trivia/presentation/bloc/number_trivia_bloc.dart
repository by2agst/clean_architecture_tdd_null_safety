import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utilities/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';

const invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(InitialNumberTriviaState()) {
    on<GetTriviaForConcreteNumber>(_concreteTriviaEventHandler);
    on<GetTriviaForRandomNumber>(_randomTriviaEventHandler);
  }

  Future<void> _concreteTriviaEventHandler(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final stringNumber = event.numberString;
    final inputEither = inputConverter.stringToUnsignedInteger(stringNumber);

    await inputEither.fold(
      (_) async => emit(
        const ErrorNumberTriviaState(
          message: invalidInputFailureMessage,
        ),
      ),
      (parsedNumber) async {
        emit(LoadingNumberTriviaState());

        final params = Params(number: parsedNumber);
        final either = await getConcreteNumberTrivia(params);

        _emitNumberTriviaRetrievalResult(either, emit);
      },
    );
  }

  Future<void> _randomTriviaEventHandler(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(LoadingNumberTriviaState());

    final either = await getRandomNumberTrivia(NoParams());

    _emitNumberTriviaRetrievalResult(either, emit);
  }

  String _mapFailureToMessage(Failure failure) {
    late final String failureMessage;

    switch (failure.runtimeType) {
      case ServerFailure:
        failureMessage = serverFailureMessage;
        break;
      case CacheFailure:
        failureMessage = cacheFailureMessage;
        break;
      default:
        failureMessage = 'Unexpected error';
        break;
    }

    return failureMessage;
  }

  void _emitNumberTriviaRetrievalResult(
    Either<Failure, NumberTrivia> either,
    Emitter<NumberTriviaState> emit,
  ) async {
    await either.fold(
      (failure) async {
        emit(
          ErrorNumberTriviaState(
            message: _mapFailureToMessage(failure),
          ),
        );
      },
      (trivia) async {
        emit(
          LoadedNumberTriviaState(
            trivia: trivia,
          ),
        );
      },
    );
  }
}
