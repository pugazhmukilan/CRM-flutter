part of 'data_ingestion_bloc.dart';

sealed class DataIngestionState extends Equatable {
  const DataIngestionState();
  
  @override
  List<Object> get props => [];
}

final class DataIngestionInitial extends DataIngestionState {}

final class DataIngestionLoading extends DataIngestionState {}
final class DataIngestionSuccess extends DataIngestionState {}
final class DataIngestionFailure extends DataIngestionState {
  final String error;
  const DataIngestionFailure(this.error);   }