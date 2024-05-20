import 'package:ecoville/utilities/packages.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationTemplate {
  Future<void> requestPermission();
  Future<Position> getCurrentLocation();
  Future<double> getDistanceBetween(
      {required Position start, required Position end});
  Future<bool> isWithinRadius(
      {required Position start, required Position end, required double radius});
  Future<bool> isWithinRadiusFromCurrentLocation(
      {required Position end, required double radius});
  Future<GeoData> getAddressFromCoordinates({required Position position});
}

class LocationRepository extends LocationTemplate {
  @override
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
    }
  }

  @override
  Future<double> getDistanceBetween(
      {required Position start, required Position end}) async {
    try {
      return Geolocator.distanceBetween(
          start.latitude, start.longitude, end.latitude, end.longitude);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error calculating distance: $e");
    }
  }

  @override
  Future<bool> isWithinRadius(
      {required Position start,
      required Position end,
      required double radius}) async {
    try {
      return Geolocator.distanceBetween(
              start.latitude, start.longitude, end.latitude, end.longitude) <=
          radius;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error calculating distance: $e");
    }
  }

  @override
  Future<bool> isWithinRadiusFromCurrentLocation(
      {required Position end, required double radius}) async {
    try {
      final currentLocation = await getCurrentLocation();
      return Geolocator.distanceBetween(currentLocation.latitude,
              currentLocation.longitude, end.latitude, end.longitude) <=
          radius;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error calculating distance: $e");
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error requesting permission: $e");
    }
  }

  @override
  Future<GeoData> getAddressFromCoordinates(
      {required Position position}) async {
    try {
      final addresses = await Geocoder.getDataFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
          googleMapApiKey: GOOGLE_MAPS_API_KEY);
      return addresses;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error getting address from coordinates: $e");
    }
  }
}
