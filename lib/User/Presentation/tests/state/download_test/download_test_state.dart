import 'package:equatable/equatable.dart';
import 'package:moatmat_app/User/Features/tests/domain/entities/test.dart';
import 'downloadable_asset.dart';

enum DownloadTestStatus {
  loading,
  downloading,
  success,
  failure,
}

class DownloadTestState extends Equatable {
  final DownloadTestStatus status;
  final String? errorMessage;
  final Test? test;
  final List<DownloadableAsset> assets;

  const DownloadTestState({
    this.status = DownloadTestStatus.loading,
    this.errorMessage,
    this.test,
    this.assets = const [],
  });

  DownloadTestState copyWith({
    DownloadTestStatus? status,
    String? errorMessage,
    Test? test,
    List<DownloadableAsset>? assets,
  }) {
    return DownloadTestState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      test: test ?? this.test,
      assets: assets ?? this.assets,
    );
  }

  DownloadTestState toFailure(String errorMessage) {
    return copyWith(status: DownloadTestStatus.failure, errorMessage: errorMessage);
  }

  DownloadTestState toSuccess() {
    return copyWith(status: DownloadTestStatus.success);
  }

  DownloadTestState toLoading() {
    return copyWith(status: DownloadTestStatus.loading);
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        test,
        assets,
      ];
}
