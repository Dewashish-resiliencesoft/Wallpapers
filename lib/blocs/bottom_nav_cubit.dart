import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavState {
  final int selectedIndex;
  final bool isVisible;

  BottomNavState({required this.selectedIndex, required this.isVisible});

  factory BottomNavState.initial() {
    return BottomNavState(selectedIndex: 0, isVisible: true);
  }

  BottomNavState copyWith({int? selectedIndex, bool? isVisible}) {
    return BottomNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavState.initial());

  void updateIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void setVisibility(bool isVisible) {
    if (state.isVisible != isVisible) {
      emit(state.copyWith(isVisible: isVisible));
    }
  }
}
