import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String numberString) {
    try {
      final parsedNumber = int.parse(numberString);

      if (parsedNumber < 0) throw const FormatException();

      return Right(parsedNumber);
    } on FormatException {
      final failure = InvalidInputFailure();

      return Left(failure);
    }
  }
}
