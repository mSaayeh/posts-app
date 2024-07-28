import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {}

final class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

final class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

final class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
