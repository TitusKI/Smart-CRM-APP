import 'dart:io';

import 'package:equatable/equatable.dart';

class GenericState<T> extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? failure;

  final T? data;
  final File? imageFile;
  const GenericState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.imageFile,
    this.failure = "",
  });
  GenericState copyWith(
      {bool? isLoading,
      bool? isSuccess,
      String? failure,
      T? data,
      File? imageFile}) {
    return GenericState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: failure ?? this.failure,
      data: data ?? this.data,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        failure,
        data,
        imageFile,
      ];
}
