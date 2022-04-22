import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_clean/core/error/exception.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

// class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on URL with number being in endpoint with application/json header',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when response code is 200 (Success)',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setupMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(
        () => call(tNumber),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should perform a GET request on URL with *random* endpoint with application/json header',
        () {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(
        mockHttpClient.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when response code is 200 (Success)',
        () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      setupMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(
        () => call(),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });
}
