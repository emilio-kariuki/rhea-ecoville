import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

class LocationCubit extends Cubit<LocationState> {
  final _locationProvider = service<LocationProvider>();
  LocationCubit() : super(const LocationState());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));
    try {
      final position = await _locationProvider.getCurrentLocation();
      
      emit(state.copyWith(
        status: LocationStatus.success,
        position: position,
      ));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error));
    }
  }
}

enum LocationStatus { initial, loading, success, error }

class LocationState {
  final LocationStatus status;
  final Position? position;

  const LocationState({
    this.status = LocationStatus.initial,
    this.position,
  });

  LocationState copyWith({
    LocationStatus? status,
    Position? position,
  }) {
    return LocationState(
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }
}
