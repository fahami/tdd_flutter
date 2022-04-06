import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean/core/error/exception.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_impl.mocks.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getlastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from sharedPreferences when there is one in cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw exception if there is nothing to cache', () {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
