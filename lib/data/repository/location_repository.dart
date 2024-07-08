import 'package:ecoville/utilities/packages.dart';
import 'dart:math';

abstract class LocationTemplate {
  Future<void> requestPermission();
  Future<Position> getCurrentLocation();
  Future<double> getDistanceBetween(
      {required Position start, required Position end});
  Future<bool> isWithinRadius(
      {required Position start, required Position end, required double radius});
  Future<bool> isWithinRadiusFromCurrentLocation(
      {required double latitude,
      required double longitude,
      required double radius});
  Future<GeoData> getAddressFromCoordinates({required Position position});
  double calculateDistanceBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude);
}

class LocationRepository extends LocationTemplate {
  @override
  Future<Position> getCurrentLocation() async {
    try {
      await requestPermission();
      final location = await Geolocator.getCurrentPosition();
      return location;
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
      {required double latitude,
      required double longitude,
      required double radius}) async {
    try {
      final currentLocation = await getCurrentLocation();
      final distance = calculateDistanceBetween(currentLocation.latitude,
          currentLocation.longitude, latitude, longitude);
      return distance <= radius;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error calculating distance: $e");
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
                    await Geolocator.openAppSettings();

        }
      }else if(permission == LocationPermission.deniedForever){
        //open app settings
        await Geolocator.openAppSettings();
      }
      bool serviceEnabled;
       serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
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
      await requestPermission();
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

  @override
  double calculateDistanceBetween(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    try {
      const double R = 6371e3;
      double first = startLatitude * pi / 180;
      double second = endLatitude * pi / 180;
      double third = (endLatitude - startLatitude) * pi / 180;
      double fourth = (endLongitude - startLongitude) * pi / 180;
      double a = sin(third / 2) * sin(third / 2) +
          cos(first) * cos(second) * sin(fourth / 2) * sin(fourth / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      double d = R * c;
      return d;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error calculating distance: $e");
    }
  }
}
