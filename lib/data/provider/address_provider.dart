import 'package:ecoville/data/repository/address_repository.dart';
import 'package:ecoville/models/address_model.dart';

class AddressProvider extends AddressTemplate {
  final AddressRepository _addressRepository;
  AddressProvider({required AddressRepository addressRepository})
      : _addressRepository = addressRepository;

  @override
  Future<bool> addAddress({required AddressModel address}) {
    return _addressRepository.addAddress(address: address);
  }

  @override
  Future<List<AddressModel>> getAddresses() {
    return _addressRepository.getAddresses();
  }

  @override
  Future<bool> removeAddress({required String id}) {
    return _addressRepository.removeAddress(id: id);
  }

  @override
  Future<bool> updateAddress({required AddressModel address}) {
    return _addressRepository.updateAddress(address: address);
  }
  
  @override
  Future<AddressModel?> getAddressById({required String id}) {
    return _addressRepository.getAddressById(id: id);
  }

  

}