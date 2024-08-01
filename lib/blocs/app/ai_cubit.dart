import 'package:ecoville/data/repository/ai_repository.dart';
import 'package:ecoville/models/title_description_model.dart';
import 'package:ecoville/utilities/packages.dart';

class AiCubit extends Cubit<AiState> {
  AiCubit() : super(AiState());

  void generateTitleAndDescription({required String query}) async {
    try {
      emit(state.copyWith(status: AiStatus.loading));
      final response =
          await AiRepository().generateTitleAndDescription(query: query);
      emit(state.copyWith(model: response, status: AiStatus.success));
    } catch (error) {
      emit(state.copyWith(status: AiStatus.error));
    }
  }
}

enum AiStatus { initial, loading, success, error }

class AiState {
  final AiStatus status;
  final TitleDescriptionModel? model;

  AiState({this.model, this.status = AiStatus.initial});

  AiState copyWith(
      {final AiStatus? status, final TitleDescriptionModel? model}) {
    return AiState(status: status ?? this.status, model: model ?? this.model);
  }
}
