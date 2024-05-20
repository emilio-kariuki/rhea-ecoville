import 'package:ecoville/data/repository/location_repository.dart';
import 'package:ecoville/utilities/packages.dart';

class LocationProvider extends LocationTemplate {
  final LocationRepository _locationRepository;
  LocationProvider({required LocationRepository locationRepository})
      : _locationRepository = locationRepository;

  @override
  Future<Position> getCurrentLocation() {
    return _locationRepository.getCurrentLocation();
  }

  @override
  Future<double> getDistanceBetween(
      {required Position start, required Position end}) {
    return _locationRepository.getDistanceBetween(start: start, end: end);
  }

  @override
  Future<bool> isWithinRadius(
      {required Position start,
      required Position end,
      required double radius}) {
    return _locationRepository.isWithinRadius(
        start: start, end: end, radius: radius);
  }

  @override
  Future<bool> isWithinRadiusFromCurrentLocation(
      {required Position end, required double radius}) {
    return _locationRepository.isWithinRadiusFromCurrentLocation(
        end: end, radius: radius);
  }

  @override
  Future<void> requestPermission() {
    return _locationRepository.requestPermission();
  }

  @override
  Future<GeoData> getAddressFromCoordinates({required Position position}) {
    return _locationRepository.getAddressFromCoordinates(position: position);
  }
}
