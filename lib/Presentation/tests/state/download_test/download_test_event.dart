import 'package:equatable/equatable.dart';

abstract class DownloadTestEvent extends Equatable {
  const DownloadTestEvent();

  @override
  List<Object?> get props => [];
}

class InitializeDownloadTestEvent extends DownloadTestEvent {
  final int testId;
  final bool? forceDownload;

  const InitializeDownloadTestEvent({required this.testId, this.forceDownload = false});

  @override
  List<Object?> get props => [testId, forceDownload];
}

class RetryDownloadTestEvent extends DownloadTestEvent {
  final int testId;

  const RetryDownloadTestEvent({required this.testId});

  @override
  List<Object?> get props => [testId];
}

class CancelDownloadTestEvent extends DownloadTestEvent {
  const CancelDownloadTestEvent();
}

class DeleteCachedTestEvent extends DownloadTestEvent {
  final int testId;

  const DeleteCachedTestEvent({required this.testId});

  @override
  List<Object?> get props => [testId];
}
