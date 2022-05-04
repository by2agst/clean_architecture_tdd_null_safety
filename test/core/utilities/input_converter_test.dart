import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/utilities/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'Should return an integer when the string represents an unsigned integer',
      () {
        // arrange
        const str = '123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, equals(const Right(123)));
      },
    );

    test('should return a failure when the string is not an integer', () {
      // arrange
      const str = 'abc';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a failure when the string is a negative integer', () {
      // arrange
      const str = '-123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
