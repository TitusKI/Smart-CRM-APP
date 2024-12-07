import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationBloc() : super(AnimationInitial()) {
    _startAnimation();
  }
  void _startAnimation() async {
    double position = -300.0;
    const double maxPosition = 300.0; // Width of the text container

    while (true) {
      await Future.delayed(const Duration(milliseconds: 20));
      position += 2.5; // Adjust speed as needed
      if (position > maxPosition) {
        position = -305.0;
      }
      // ignore: invalid_use_of_visible_for_testing_member
      emit(AnimationMoving(position));
    }
  }

  Stream<AnimationState> mapEventToState(AnimationEvent event) async* {
    if (event is StartAnimation) {
      double position = -305.0;
      while (true) {
        await Future.delayed(const Duration(milliseconds: 20));
        position = (position >= 300.0) ? -305.0 : position + 2.5;
        yield AnimationMoving(position);
      }
    } else if (event is StopAnimation) {
      yield AnimationInitial();
    }
  }
}
