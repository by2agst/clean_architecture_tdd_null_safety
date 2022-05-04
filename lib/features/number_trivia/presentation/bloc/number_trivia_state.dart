part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class InitialNumberTriviaState extends NumberTriviaState {}

class LoadingNumberTriviaState extends NumberTriviaState {}

class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTrivia trivia;

  const LoadedNumberTriviaState({required this.trivia});
}

class ErrorNumberTriviaState extends NumberTriviaState {
  final String message;

  const ErrorNumberTriviaState({required this.message});
}
