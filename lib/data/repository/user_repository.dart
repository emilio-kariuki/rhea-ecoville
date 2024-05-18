import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

/*
1. create a user after successful authentication [done]
2. get the user details [done]
3. update the user details [done]
4. get the products they have posted on the app  [done]
6. get the products they have purchased
7. get the products they have sold
8. get the products they have saved on the app [done]
9 get all the bids they have made on the app
10. get all the bids they have received on the app

*/

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<UserModel> getUser();
  Future<UserModel> updateUser({required UserModel user});
  Future<List<ProductModel>> getProductsPosted();
  Future<List<ProductModel>> getProductsSaved();
}

class UserRepository extends UserTemplate {
  final _dbHelper = service<DatabaseHelper>();
  @override
  Future<bool> createUser({required UserModel user}) async {
    try {
      final response =
          await supabase.from(TABLE_USERS).select().eq('id', user.id);
      if (response.isEmpty) {
        await supabase.from('User').insert({
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'image': user.image,
          'token': user.token,
          'phone': '',
          'address': {
            'city': '',
            'lat': 0.0,
            'lon': 0.0,
            'country': 'Kenya',
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

  @override
  Future<List<ProductModel>> getProductsPosted() async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response =
          await supabase.from(TABLE_PRODUCT).select().eq('userId', id);
      final products = response.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting products posted by user');
    }
  }

  @override
  Future<List<ProductModel>> getProductsSaved() async {
    try {
      final db = await _dbHelper.init();
      return await _dbHelper.getUserLocalProducts(
        db: db,
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting products liked by user');
    }
  }

  
}
