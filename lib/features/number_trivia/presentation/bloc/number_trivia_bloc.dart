import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'events/number_trivia_event.dart';
part 'state/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
