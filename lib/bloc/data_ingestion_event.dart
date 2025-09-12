part of 'data_ingestion_bloc.dart';

sealed class DataIngestionEvent extends Equatable {
  const DataIngestionEvent();

  @override
  List<Object> get props => [];
}


final class UploadFileEvent extends DataIngestionEvent {
  final List<Map<String, dynamic>> jsonData;
  const UploadFileEvent(this.jsonData);

  @override
  List<Object> get props => [jsonData];
}