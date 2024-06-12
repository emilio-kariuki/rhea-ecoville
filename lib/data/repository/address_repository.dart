import 'package:ecoville/data/local/local_database.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class AddressTemplate {
  Future<bool> addAddress({required AddressModel address});
  Future<bool> removeAddress({required String id});
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel?> getAddressById({required String id});
  Future<bool> updateAddress({required AddressModel address});
}

class AddressRepository extends AddressTemplate {
  final _dbHelper = service<DatabaseHelper>();
  @override
  Future<bool> addAddress({required AddressModel address}) async {
    try {
      final db = await _dbHelper.init();
      final result = await db.insert(LOCAL_TABLE_ADDRESS, address.toJson());
      return result > 0;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final db = await _dbHelper.init();
      final result = await db.query(LOCAL_TABLE_ADDRESS);
      return result.map((e) => AddressModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint(error.toString());
      return [];
    }
  }

  @override
  Future<bool> removeAddress({required String id}) async {
    try {
      final db = await _dbHelper.init();
      await db.delete(LOCAL_TABLE_ADDRESS, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  @override
  Future<bool> updateAddress({required AddressModel address}) async {
    try {
      final db = await _dbHelper.init();
      final result = await db.update(LOCAL_TABLE_ADDRESS, address.toJson(),
          where: 'id = ?', whereArgs: [address.id]);
      return result > 0;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }
  
  @override
  Future<AddressModel?> getAddressById({required String id}) async{
    try {
      final db = await _dbHelper.init();
      final result = await db.query(LOCAL_TABLE_ADDRESS, where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return AddressModel.fromJson(result.first);
      }
      return null;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
