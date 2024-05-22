import 'package:ecoville/data/provider/product_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/bid_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class BidTemplate {
  Future<bool> createBid({required BidModel bid});
  Future<bool> updateBid({required BidModel bid});
  Future<bool> deleteBid({required String id});
  Future<List<BidModel>> getProductBids({required String productId});
  Future<List<BidModel>> getUserBids({required String userId});
  Future<bool> notifyWinner();
}

class BidRepository extends BidTemplate {
  final _productProvider = service<ProductProvider>();
  @override
  Future<bool> createBid({required BidModel bid}) async {
    try {
      final product = await _productProvider.getProduct(id: bid.productId);
      if (product.allowBidding) {
        if (product.currentPrice < bid.price) {
          await supabase.from(TABLE_BIDDING).insert([
            {
              'id': bid.id,
              'productId': bid.productId,
              'userId': bid.userId,
              'price': bid.price,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }
          ]);
          await supabase
              .from(TABLE_PRODUCT)
              .update({"currentPrice": bid.price}).eq("id", bid.productId);
        } else {
          throw Exception('Bid must be higher than current price');
        }
      } else {
        throw Exception("Bids cannot be placed at this placement");
      }

      return true;
    } catch (error) {
      debugPrint("Error creating bid: $error");
      throw Exception("Error creating bid: $error");
    }
  }

  @override
  Future<bool> updateBid({required BidModel bid}) async {
    try {
      final product = await _productProvider.getProduct(id: bid.productId);
      if (product.allowBidding) {
        if (product.currentPrice < bid.price) {
          await supabase.from(TABLE_BIDDING).update({
            'productId': bid.productId,
            'userId': bid.userId,
            'price': bid.price,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          }).eq("id", bid.id);
          await supabase
              .from(TABLE_PRODUCT)
              .update({"currentPrice": bid.price}).eq("id", bid.productId);
        } else {
          throw Exception('Bid must be higher than current price');
        }
      } else {
        throw Exception("Bids cannot be placed at this placement");
      }

      return true;
    } catch (error) {
      debugPrint("Error updating bid: $error");
      throw Exception("Error updating bid: $error");
    }
  }

  @override
  Future<bool> deleteBid({required String id}) async {
    try {
      await supabase.from(TABLE_BIDDING).delete().eq('id', id);
      return true;
    } catch (error) {
      debugPrint("Error deleting bid: $error");
      throw Exception("Error deleting bid: $error");
    }
  }

  @override
  Future<List<BidModel>> getProductBids({required String productId}) async {
    try {
      final response = await supabase
          .from(TABLE_BIDDING)
          .select(
            "ecoville_user(*), ecoville_product(*), *",
          )
          .eq('productId', productId);
      debugPrint("Bids are: $response");
      final bids = response.map((e) => BidModel.fromJson(e)).toList();
      return bids;
    } catch (error) {
      debugPrint("Error fetching bids: $error");
      throw Exception("Error fetching bids: $error");
    }
  }

  @override
  Future<List<BidModel>> getUserBids({required String userId}) async {
    try {
      final bids =
          await supabase.from(TABLE_BIDDING).select("*").eq('userId', userId);
      return bids.map((e) => BidModel.fromJson(e)).toList();
    } catch (error) {
      debugPrint("Error fetching user bids: $error");
      throw Exception("Error fetching user bids: $error");
    }
  }
  
  @override
  Future<bool> notifyWinner() async{
    try{
      final response = await supabase.from(TABLE_BIDDING).select("ecoville_user(*), ecoville_product(*)").order("price", ascending: false).limit(1);
      final winner = BidModel.fromJson(response.first);
      final product = await _productProvider.getProduct(id: winner.productId);
      // await _productProvider.updateProduct(product: product.copyWith(winnerId: winner.userId));
      return true;

    }catch(error){
      debugPrint("Error notifying the winner: $error");
      throw Exception("Error notifying the winner: $error");
    }
  }
}
