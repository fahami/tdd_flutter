import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean/core/network/network_info.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:tdd_clean/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

// class MockRemoteDataSource extends Mock
//     implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}

@GenerateMocks([NetworkInfo])
@GenerateMocks([
  NumberTriviaRemoteDataSource
], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockNumberTriviaRemoteDataSourceForTest,
      returnNullOnMissingStub: true)
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('get concrete number trivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tnumberTrivia = tNumberTriviaModel;

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when call to remote data source is succeed',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tnumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });
  });
}
