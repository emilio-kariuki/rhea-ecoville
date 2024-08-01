import 'package:ecoville/blocs/app/orders_cubit.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/utilities/packages.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

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
                          return const Center(child: CircularProgressIndicator());
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),

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
        ],
      ),
    );
  }
}
