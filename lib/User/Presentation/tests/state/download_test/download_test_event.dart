import 'package:equatable/equatable.dart';

abstract class DownloadTestEvent extends Equatable {
  const DownloadTestEvent();

  @override
  List<Object?> get props => [];
}

class InitializeDownloadTest extends DownloadTestEvent {
  final int testId;

  const InitializeDownloadTest({required this.testId});

  @override
  List<Object?> get props => [testId];
}

class CancelDownloadTest extends DownloadTestEvent {
  const CancelDownloadTest();
}
