import 'package:ecoville/data/provider/address_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

class AddressCubit extends Cubit<AddressState> {
  final _addressProvider = service<AddressProvider>();
  AddressCubit() : super(AddressState());

  Future<void> addAddress({required AddressModel address}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressProvider.addAddress(address: address);
      if (result) {
        emit(state.copyWith(status: AddressStatus.success));
      } else {
        emit(state.copyWith(
            status: AddressStatus.error, message: 'Failed to add address'));
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }

  Future<void> getAddresses() async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final addresses = await _addressProvider.getAddresses();
      emit(state.copyWith(status: AddressStatus.success, addresses: addresses));
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }

  Future<void> removeAddress({required String id}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressProvider.removeAddress(id: id);
      if (result) {
        final addresses = await _addressProvider.getAddresses();
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
        ));
      } else {
        emit(state.copyWith(
            status: AddressStatus.error, message: 'Failed to remove address'));
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }

  Future<void> updateAddress({required AddressModel address}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressProvider.updateAddress(address: address);
      if (result) {
        final addresses = await _addressProvider.getAddresses();
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
        ));
      } else {
        emit(state.copyWith(
            status: AddressStatus.error, message: 'Failed to update address'));
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }

  Future<void> getAddressById({required String id}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final address = await _addressProvider.getAddressById(id: id);
      emit(state.copyWith(
          status: AddressStatus.success, selectedAddress: address));
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }
}

enum AddressStatus { initial, loading, success, error }

class AddressState {
  final AddressStatus status;
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final String message;

  AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.selectedAddress,
    this.message = '',
  });

  AddressState copyWith({
    AddressStatus? status,
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    String? message,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      message: message ?? this.message,
    );
  }
}
