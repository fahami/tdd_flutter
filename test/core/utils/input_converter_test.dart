import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsigned integer', () {
    test('should return integer when the string represents an unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', () async {
      // arrange
      const str = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });

    test('should return a Failure when the string represents an signed integer',
        () async {
      // arrange
      const str = '-123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, equals(Left(InvalidInputFailure())));
    });
  });
}
