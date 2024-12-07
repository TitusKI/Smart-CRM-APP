part of 'animation_bloc.dart';

abstract class AnimationEvent extends Equatable {
  const AnimationEvent();

  @override
  List<Object> get props => [];
}

class StartAnimation extends AnimationEvent {}

class StopAnimation extends AnimationEvent {}
