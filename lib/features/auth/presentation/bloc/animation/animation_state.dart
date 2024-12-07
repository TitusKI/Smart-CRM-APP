part of 'animation_bloc.dart';

abstract class AnimationState extends Equatable {
  const AnimationState();

  @override
  List<Object> get props => [];
}

final class AnimationInitial extends AnimationState {}

class AnimationMoving extends AnimationState {
  final double position;
  const AnimationMoving(this.position);
  @override
  List<Object> get props => [position];
}
