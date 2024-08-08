import 'package:ecoville/data/repository/bid_repository.dart';
import 'package:ecoville/models/bid_model.dart';

class BidProvider extends BidTemplate {
  final BidRepository _bidRepository;
  BidProvider({required BidRepository bidRepository})
      : _bidRepository = bidRepository;

  @override
  Future<bool> createBid({required String productId, required int price}) {
    return _bidRepository.createBid(
      productId: productId,
      price: price,
    );
  }

  @override
  Future<bool> deleteBid({required String id}) {
    return _bidRepository.deleteBid(id: id);
  }
  
  @override
  Future<List<BidsModel>> getProductBids({required String productId}) {
    return _bidRepository.getProductBids(productId: productId);
  }

  @override
  Future<List<BidsModel>> getUserBids() {
    return _bidRepository.getUserBids();
  }

  @override
  Future<bool> updateBid({required String bidId, required int price}) {
    return _bidRepository.updateBid(
      bidId: bidId,
      price: price,
    );
  }
}
