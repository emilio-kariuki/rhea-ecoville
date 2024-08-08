import 'package:dio/dio.dart';
import 'package:ecoville/data/provider/bid_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/bid_model.dart';
import 'package:ecoville/utilities/packages.dart';

/// `BidCubit` manages the state and business logic related to bids.
/// This class extends `Cubit<BidState>` and handles various actions such as creating, updating, and deleting bids.
class BidCubit extends Cubit<BidState> {
  final _bidProvider = service<BidProvider>();
  BidCubit() : super(BidState());

  /// Creates a new bid for a product.
  /// Emits a loading state while the operation is in progress, and either a success or error state depending on the outcome.
  Future<void> createBid({required String productId, required int price}) async {
    try {
      emit(state.copyWith(status: BidStatus.loading)); // Emit loading state before making the API call.
      final bool isCreated = await _bidProvider.createBid(
          productId: productId, price: price
      );
      if (isCreated) {
        emit(state.copyWith(
            status: BidStatus.success, message: 'Bid created successfully'));
      } else {
        emit(state.copyWith(
            status: BidStatus.error, message: 'Failed to create bid'));
      }
    } on DioException catch (error) { // Handle Dio-specific exceptions and emit an error state.
      emit(state.copyWith(status: BidStatus.error, message: error.message));
    }
  }

  /// Updates an existing bid.
  Future<void> updateBid({required String bidId, required int price}) async {
    try {
      emit(state.copyWith(status: BidStatus.loading));
      final bool isUpdated = await _bidProvider.updateBid(
          bidId: bidId, price: price
      );
      if (isUpdated) {
        emit(state.copyWith(
            status: BidStatus.success, message: 'Bid updated successfully'));
      } else {
        emit(state.copyWith(
            status: BidStatus.error, message: 'Failed to update bid'));
      }
    } catch (error) { // Handle general exceptions and emit an error state.
      emit(state.copyWith(status: BidStatus.error, message: error.toString().toException()));
    }
  }

  /// Deletes an existing bid.
  Future<void> deleteBid({required String id}) async {
    try {
      emit(state.copyWith(status: BidStatus.loading));
      final bool isDeleted = await _bidProvider.deleteBid(id: id);
      if (isDeleted) {
        emit(state.copyWith(
            status: BidStatus.success, message: 'Bid deleted successfully'));
      } else {
        emit(state.copyWith(
            status: BidStatus.error, message: 'Failed to delete bid'));
      }
    } catch (error) {
      emit(state.copyWith(status: BidStatus.error, message: error.toString()));
    }
  }

  /// Fetches all bids related to a specific product.
  Future<void> getProductBids({required String productId}) async {
    try {
      emit(state.copyWith(status: BidStatus.loading));
      final bids =
          await _bidProvider.getProductBids(productId: productId);
      emit(state.copyWith(status: BidStatus.success, bids: bids));
    } catch (error) {
      emit(state.copyWith(status: BidStatus.error, message: error.toString()));
    }
  }

  /// Fetches all bids made by the current user.
  Future<void> getUserBids() async {
    try {
      emit(state.copyWith(status: BidStatus.loading));
      final bids =
          await _bidProvider.getUserBids();
      emit(state.copyWith(status: BidStatus.success, bids: bids));
    } catch (error) {
      emit(state.copyWith(status: BidStatus.error, message: error.toString()));
    }
  }
}

enum BidStatus { initial, loading, success, error }

class BidState {
  final BidStatus status;
  final String message;
  final BidsModel? bid;
  final List<BidsModel> bids;

  BidState({
    this.status = BidStatus.initial,
    this.message = '',
    this.bid,
    this.bids = const [],
  });

  BidState copyWith({
    BidStatus? status,
    String? message,
    BidsModel? bid,
    List<BidsModel>? bids,
  }) {
    return BidState(
      status: status ?? this.status,
      message: message ?? this.message,
      bid: bid ?? this.bid,
      bids: bids ?? this.bids,
    );
  }
}
