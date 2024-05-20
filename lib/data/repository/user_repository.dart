import 'package:ecoville/data/provider/location_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<UserModel> getUser();
  Future<UserModel> updateUser({required UserModel user});
}

class UserRepository extends UserTemplate {
  @override
  Future<bool> createUser({required UserModel user}) async {
    try {
      final response =
          await supabase.from(TABLE_USERS).select().eq('id', user.id);
      final location = await service<LocationProvider>().getCurrentLocation();
      final address = await service<LocationProvider>()
          .getAddressFromCoordinates(position: location);
      if (response.isEmpty) {
        await supabase.from('User').insert({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'image': user.image,
          'token': user.token,
          'phone': '',
          'address': {
            'city': address.city,
            'lat': address.latitude,
            'lon': address.longitude,
            'country': address.country,
          }
        });
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final id = supabase.auth.currentUser!.id;
      debugPrint("id: $id");
      final response = await supabase.from(TABLE_USERS).select().eq('id', id);
      final user = UserModel.fromJson(response.first);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user');
    }
  }

  @override
  Future<UserModel> updateUser({required UserModel user}) async {
    try {
      await supabase.from(TABLE_USERS).update({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'image': user.image,
        'token': user.token,
        'address': {
          'city': user.address!.city,
          'lat': user.address!.lat,
          'lon': user.address!.lon,
          'country': user.address!.country,
        }
      }).eq('id', user.id);
      final result = await getUser();
      return result;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error updating user');
    }
  }
}
