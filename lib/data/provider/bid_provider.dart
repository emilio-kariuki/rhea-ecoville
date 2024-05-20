import 'package:ecoville/data/repository/Bid_repository.dart';
import 'package:ecoville/models/bid_model.dart';

class BidProvider extends BidTemplate {
  final BidRepository _bidRepository;
  BidProvider({required BidRepository bidRepository})
      : _bidRepository = bidRepository;

  @override
  Future<bool> createBid({required BidModel bid}) {
    return _bidRepository.createBid(bid: bid);
  }

  @override
  Future<bool> deleteBid({required String id}) {
    return _bidRepository.deleteBid(id: id);
  }

  @override
  Future<List<BidModel>> getProductBids({required String productId}) {
    return _bidRepository.getProductBids(productId: productId);
  }

  @override
  Future<List<BidModel>> getUserBids({required String userId}) {
    return _bidRepository.getUserBids(userId: userId);
  }

  @override
  Future<bool> updateBid({required BidModel bid}) {
    return _bidRepository.updateBid(bid: bid);
  }
}
