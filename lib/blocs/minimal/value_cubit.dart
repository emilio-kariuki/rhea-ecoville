import 'package:bloc/bloc.dart';

class ValueCubit extends Cubit<ValueState> {
  ValueCubit() : super(const ValueState());

  void changeValue({required String value}) {
    emit(
      state.copyWith(
        value: value,
        status: ValueStatus.changed,
      ),
    );
  }
}

enum ValueStatus { initial, changed }

class ValueState {
  final String value;
  final ValueStatus status;
  const ValueState({
    this.value = '',
    this.status = ValueStatus.initial,
  });

  ValueState copyWith({
    String? value,
    ValueStatus? status,
  }) {
    return ValueState(
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }
}
