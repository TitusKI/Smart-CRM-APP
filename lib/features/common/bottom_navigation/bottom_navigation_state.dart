part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  final int navIndex;
  const BottomNavigationState({
    this.navIndex = 0,
  });
  BottomNavigationState copyWith({
    int? navIndex,
  }) {
    return BottomNavigationState(
      navIndex: navIndex ?? this.navIndex,
    );
  }

  @override
  List<Object> get props => [navIndex];
}
