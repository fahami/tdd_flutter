import 'package:tdd_clean/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean/core/usecases/usecase.dart';
import 'package:tdd_clean/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    return repository.getRandomNumberTrivia();
  }
}
