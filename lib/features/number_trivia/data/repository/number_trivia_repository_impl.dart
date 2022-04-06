import 'package:tdd_clean/core/error/exception.dart';
import 'package:tdd_clean/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean/core/network/network_info.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomNumber = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTriviaModel>> _getTrivia(
      _ConcreteOrRandomNumber getNumberTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await getNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await getNumberTrivia();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
