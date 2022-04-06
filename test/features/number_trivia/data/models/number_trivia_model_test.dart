import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test');
  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model when JSON number is integer', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test('should return valid model when JSON number is regarded a double', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "test",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
