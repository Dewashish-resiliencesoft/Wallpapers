import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarCubit extends Cubit<bool> {
  AppBarCubit() : super(false);

  void setCollapsed(bool value) {
    if (state != value) {
      emit(value);
    }
  }
}
