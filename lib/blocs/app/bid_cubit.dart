import 'package:dio/dio.dart';
import 'package:ecoville/data/provider/bid_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/bid_model.dart';
import 'package:ecoville/utilities/packages.dart';

class BidCubit extends Cubit<BidState> {
  final _bidProvider = service<BidProvider>();
  BidCubit() : super(BidState());

  Future<void> createBid({required String productId, required int price}) async {
    try {
      emit(state.copyWith(status: BidStatus.loading));
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
    } on DioException catch (error) {
      emit(state.copyWith(status: BidStatus.error, message: error.message));
    }
  }

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
    } catch (error) {
      emit(state.copyWith(status: BidStatus.error, message: error.toString().toException()));
    }
  }

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
