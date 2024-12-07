import 'package:equatable/equatable.dart';

class GenericState<T> extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? failure;

  final T? data;
  const GenericState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure = "",
  });
  GenericState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? failure,
    T? data,
  }) {
    return GenericState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure ?? this.failure,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        failure,
        data,
      ];
}
