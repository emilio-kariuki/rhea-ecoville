import 'package:ecoville/data/provider/address_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/address_model.dart';
import 'package:ecoville/utilities/packages.dart';

/// `AddressCubit` class to manage address-related states and interactions.
/// This class extends `Cubit<AddressState>` and handles adding, fetching,
/// updating, and deleting addresses using the AddressProvider.
class AddressCubit extends Cubit<AddressState> {
  final _addressProvider = service<AddressProvider>(); // Initializing AddressProvider using service locator.
  AddressCubit() : super(AddressState()); // Constructor initializing the cubit with an initial state.

  /// Method to add a new address.
  Future<void> addAddress({required AddressRequestModel address}) async {
    emit(state.copyWith(status: AddressStatus.loading)); // Emitting a loading state.
    try {
      final result = await _addressProvider.addAddress(address: address); // Calling the addAddress method from the provider.
      if (result) {
        emit(state.copyWith(status: AddressStatus.added));
      } else {
        emit(state.copyWith(
            status: AddressStatus.error, message: 'Failed to add address'));
      }
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));// Handling exceptions and emitting error state.
    }
  }

  /// Method to fetch all addresses.
  Future<void> getAddresses() async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final addresses = await _addressProvider.getAddresses(); // Calling the getAddresses method from the provider.
      emit(state.copyWith(status: AddressStatus.success, addresses: addresses));
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }

  /// Method to remove an address by its ID.
  Future<void> removeAddress({required String id}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressProvider.removeAddress(id: id); // Calling the removeAddress method from the provider.
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

  /// Method to update an existing address by its ID.
  Future<void> updateAddress({required AddressRequestModel address, required String id}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final result = await _addressProvider.updateAddress(address: address, id: id); // Calling the updateAddress method from the provider.
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

  /// Method to fetch a specific address by its ID.
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
  
  /// Method to delete a specific address by its ID and refresh the address list.
  Future<void> deleteAddressById({required String id}) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      await _addressProvider.removeAddress(id: id);
      await getAddresses();
      emit(state.copyWith(
          status: AddressStatus.success, ));
    } catch (e) {
      emit(state.copyWith(status: AddressStatus.error, message: e.toString()));
    }
  }
}

/// Enum representing the possible states of address operations.
enum AddressStatus { initial, loading,added, success, error }

/// `AddressState` class to represent the state of the address operations.
class AddressState {
  final AddressStatus status; // Current status of the address operation.
  final List<AddressModel> addresses; // List of addresses.
  final AddressModel? selectedAddress; // Currently selected address.
  final String message; // Message for displaying errors or status.

  AddressState({
    this.status = AddressStatus.initial, // Default status is `initial`.
    this.addresses = const [], // Default addresses list is empty.
    this.selectedAddress,
    this.message = '', // Default message is empty
  });

  /// Method to create a copy of the current state with updated properties.
  AddressState copyWith({
    AddressStatus? status,
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    String? message,
  }) {
    return AddressState(
      status: status ?? this.status, // Keeping current status if not provided.
      addresses: addresses ?? this.addresses, // Keeping current addresses if not provided.
      selectedAddress: selectedAddress ?? this.selectedAddress, // Keeping current selected address if not provided.
      message: message ?? this.message, // Keeping current message if not provided.
    );
  }
}
