import 'package:ecoville/blocs/app/orders_cubit.dart';
import 'package:ecoville/blocs/app/rating_cubit.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/utilities/packages.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          surfaceTintColor: white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.all(13),
            child: GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  AppImages.back,
                  color: black,
                  height: 2.5 * SizeConfig.heightMultiplier,
                )),
          ),
          title: Text(
            "Orders",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: BlocProvider(
              create: (context) => OrderCubit(),
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Orders",
                          style: GoogleFonts.inter(
                              fontSize: 1.5 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w600,
                              color: green),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context.read<OrderCubit>().getUserOrders();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: green,
                            size: 2.5 * SizeConfig.heightMultiplier,
                          ),
                        ),
                      ],
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    BlocConsumer<OrderCubit, OrderState>(
                      buildWhen: (previous, current) =>
                          previous.orders != current.orders,
                      bloc: context.read<OrderCubit>()..getUserOrders(),
                      listener: (context, state) {
                        if (state.status == OrderStatus.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        }

                        if (state.status == OrderStatus.updated) {
                          context.read<OrderCubit>().getUserOrders();
                        }
                      },
                      builder: (context, state) {
                        if (state.status == OrderStatus.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state.status == OrderStatus.loaded) {
                          return Column(
                            children: [
                              for (var order in state.orders)
                                Column(
                                  children: [
                                    OrderTile(order: order),
                                    Gap(1 * SizeConfig.heightMultiplier),
                                  ],
                                ),
                            ],
                          );
                        } else {
                          return const Center(child: Text("No orders found"));
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ));
  }
}

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${order.id}",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w400,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "${order.quantity} item(s)",
            style: GoogleFonts.inter(
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "Ksh ${order.totalPrice}",
            style: TextStyle(
                fontSize: 2 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w700,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "Status: ${order.status}",
            style: GoogleFonts.inter(
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w600,
              color: order.status == "pending"
                  ? Colors.orange
                  : order.status == "delivered"
                      ? Colors.green
                      : order.status == "cancelled"
                          ? Colors.red
                          : order.status == "shipped"
                              ? Colors.blue
                              : order.status == 'completed'
                                  ? Colors.green
                                  : Colors.black,
            ),
          ),
          // cancel button
          if (order.status == "pending")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () {
                  context.read<OrderCubit>().cancelOrder(order: order);
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                ),
                child: Text(
                  "Cancel Order",
                  style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

          // confirm button
          if (order.status == "delivered")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () {
                  context.read<OrderCubit>().confirmOrder(order: order);
                },
                child: Text(
                  "Confirm Order",
                  style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

          if (order.status == "confirmed")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () => showModalBottomSheet(
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: white,
                    isScrollControlled: true,
                    barrierColor: Colors.black.withOpacity(0.6),
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(27.25),
                            topRight: Radius.circular(27.25))),
                    context: context,
                    builder: (context) {
                      final _reviewController = TextEditingController();
                      final _ratingController = TextEditingController();
                      return Container(
                        padding: const EdgeInsets.all(15),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Review",
                                style: GoogleFonts.inter(
                                    fontSize: 2.2 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                              Gap(2 * SizeConfig.heightMultiplier),
                              InputField(
                                controller: _reviewController,
                                maxLines: 5,
                                minLines: 3,
                                hintText: "Type your review here",
                                validator: (p0) {
                                  return null;
                                },
                              ),
                              Gap(1 * SizeConfig.heightMultiplier),
                              
                              InputField(
                                controller: _ratingController,
                                textInputType: TextInputType.number,
                                hintText: "Type your rating here",
                                validator: (p0) {
                                  return null;
                                },
                              ),
                              Gap(2 * SizeConfig.heightMultiplier),
                              BlocProvider(
                                create: (context) => RatingCubit(),
                                child: BlocConsumer<RatingCubit, RatingState>(
                                  listener: (context, state) {
                                    if (state.status == RatingStatus.success) {
                                      context.pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return CompleteButton(
                                      function: () {
                                        if (_reviewController.text.isNotEmpty) {
                                          context.read<RatingCubit>().addRating(
                                              productId: order.productId,
                                              review: _reviewController.text,
                                              rating: double.parse(
                                                  _ratingController.text),
                                              sellerId: order.product.userId);
                                        }
                                      },
                                      isLoading:
                                          state.status == RatingStatus.loading,
                                      text: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Text(
                                          "Add Rating",
                                          style: GoogleFonts.inter(
                                              fontSize: 1.8 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.w600,
                                              color: white),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                child: Text(
                  "Add Review",
                  style: GoogleFonts.inter(
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
