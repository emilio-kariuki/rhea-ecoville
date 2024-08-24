import 'package:ecoville/blocs/app/app_cubit.dart';
import 'package:ecoville/blocs/app/orders_cubit.dart';
import 'package:ecoville/blocs/app/rating_cubit.dart';
import 'package:ecoville/models/order_model.dart';
import 'package:ecoville/shared/complete_button.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(),
      child: Builder(builder: (context) {
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
              actions: [
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: GestureDetector(
                      onTap: () => context.read<OrderCubit>().getUserOrders(),
                      child: SvgPicture.asset(
                        AppImages.refresh,
                        color: black,
                        height: 2.5 * SizeConfig.heightMultiplier,
                      )),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<OrderCubit>().getUserOrders();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Builder(builder: (context) {
                    return BlocConsumer<OrderCubit, OrderState>(
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
                          return state.orders.isEmpty
                              ? SizedBox(
                                  height: 80 * SizeConfig.heightMultiplier,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.watch,
                                          height:
                                              20 * SizeConfig.heightMultiplier,
                                        ),
                                        Gap(1 * SizeConfig.heightMultiplier),
                                        Text(
                                          "Your Orders are empty",
                                          style: GoogleFonts.inter(
                                            fontSize:
                                                2.2 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: black,
                                          ),
                                        ),
                                        Text(
                                          "You have not placed any orders yet",
                                          style: GoogleFonts.inter(
                                            fontSize:
                                                1.6 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w400,
                                            color: darkGrey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    context.read<OrderCubit>().getUserOrders();
                                  },
                                  child: Column(
                                    children: [
                                      for (var order in state.orders)
                                        Column(
                                          children: [
                                            OrderTile(order: order),
                                            Gap(1 *
                                                SizeConfig.heightMultiplier),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                        } else {
                          return const Center(child: Text("No orders found"));
                        }
                      },
                    );
                  }),
                ),
              ),
            ));
      }),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderModel order;

  OrderTile({super.key, required this.order});

  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NetworkImageContainer(
                imageUrl: order.product.image[0],
                height: 40,
                width: 40,
                borderRadius: BorderRadius.circular(10),
              ),
              Gap(2 * SizeConfig.widthMultiplier),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      order.product.name,
                      style: GoogleFonts.inter(
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.w600,
                          color: black),
                    ),
                  ),
                  Text(
                    "Ksh ${order.product.price}",
                    style: GoogleFonts.inter(
                        fontSize: 1.8 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: black),
                  ),
                ],
              ),
            ],
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: order.status == "pending"
                      ? Colors.orange.withOpacity(0.2)
                      : order.status == "confirmed"
                          ? Colors.pink.withOpacity(0.2)
                          : order.status == "delivered & paid"
                              ? Colors.green.withOpacity(0.2)
                              : order.status == "delivered & notpaid"
                                  ? Colors.green.withOpacity(0.5)
                                  : order.status == "cancelled"
                                      ? Colors.red.withOpacity(0.2)
                                      : order.status == "shipped"
                                          ? Colors.blue.withOpacity(0.2)
                                          : order.status == 'completed'
                                              ? Colors.purple.withOpacity(0.2)
                                              : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  order.status,
                  style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: order.status == "pending"
                        ? Colors.orange
                        : order.status == "confirmed"
                            ? Colors.pink
                            : order.status == "delivered & paid"
                                ? Colors.green
                                : order.status == "delivered & notpaid"
                                    ? const Color.fromARGB(255, 30, 71, 31)
                                    : order.status == "cancelled"
                                        ? Colors.red
                                        : order.status == "shipped"
                                            ? Colors.blue
                                            : order.status == 'completed'
                                                ? Colors.purple
                                                : Colors.red,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "${DateFormat.yMMMMd().format(order.updatedAt)} at ${DateFormat.jm().format(order.updatedAt)}",
                style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: black),
              ),
            ],
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Text(
            "#${order.id}",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w700,
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
            "Charges includeds:",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Item cost: Ksh ${order.product.price}",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  "Delivery Fee: Ksh ${129}",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  "Service Fee: Ksh ${0.05 * order.product.price.toInt()}",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Gap(0.5 * SizeConfig.heightMultiplier),
                Text(
                  "Total: Ksh ${order.totalPrice}",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w700,
                      color: black),
                )
              ],
            ),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "Delivery Address",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.user.addresses[0].name,
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  "${order.user.addresses[0].region}, ${order.user.addresses[0].city}, Kenya",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                // phone number
                Text(
                  order.user.addresses[0].email,
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  order.user.addresses[0].phone,
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  "${order.user.addresses[0].altPhone} (Alt)",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                Text(
                  order.user.addresses[0].address ?? "",
                  style: GoogleFonts.inter(
                      fontSize: 1.4 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
              ],
            ),
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          Text(
            "Payment Method",
            style: GoogleFonts.inter(
                fontSize: 1.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Text(
              "Payment on delivery - M-Pesa",
              style: GoogleFonts.inter(
                  fontSize: 1.4 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
          ),
          Gap(2 * SizeConfig.heightMultiplier),
          // cancel button
          if (order.status == "pending")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  context.read<OrderCubit>().confirmOrder(order: order);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel Order",
                      style: GoogleFonts.inter(
                        fontSize: 1.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          //return button
          if (order.status == "returned")
            Column(
              children: [
                BlocProvider(
                  create: (context) => AppCubit(),
                  child: Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () => context
                            .read<AppCubit>()
                            .launchPhone("+254796250443"),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              "Call for more details",
                              style: GoogleFonts.inter(
                                fontSize: 1.5 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      context.read<OrderCubit>().confirmOrder(order: order);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.purple.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel return request",
                          style: GoogleFonts.inter(
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // confirm button
          if (order.status == "delivered & paid")
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  context.read<OrderCubit>().confirmOrder(order: order);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      "Confirm Order",
                      style: GoogleFonts.inter(
                        fontSize: 1.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (order.status == "delivered & notpaid")
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputField(
                      hintText: "2547*********",
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      }),
                  BlocConsumer<OrderCubit, OrderState>(
                    listener: (context, state) {
                      if (state.status == OrderStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<OrderCubit>().payOrder(
                                  orderId: order.id,
                                  phone: _phoneController.text,
                                  amount: order.totalPrice);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.green.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                state.status == OrderStatus.loading
                                    ? "Processing..."
                                    : "Pay Order",
                                style: GoogleFonts.inter(
                                  fontSize: 1.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          if (order.status == "completed")
            Column(
              children: [
                if (!order.reviewed)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
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
                            final reviewController = TextEditingController();
                            final ratingController = TextEditingController();
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
                                          fontSize:
                                              2.2 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                    Gap(2 * SizeConfig.heightMultiplier),
                                    InputField(
                                      controller: reviewController,
                                      maxLines: 5,
                                      minLines: 3,
                                      hintText: "Type your review here",
                                      validator: (p0) {
                                        return null;
                                      },
                                    ),
                                    Gap(1 * SizeConfig.heightMultiplier),
                                    InputField(
                                      controller: ratingController,
                                      textInputType: TextInputType.number,
                                      hintText: "Type your rating here",
                                      validator: (p0) {
                                        return null;
                                      },
                                    ),
                                    Gap(2 * SizeConfig.heightMultiplier),
                                    BlocProvider(
                                      create: (context) => RatingCubit(),
                                      child: BlocConsumer<RatingCubit,
                                          RatingState>(
                                        listener: (context, state) {
                                          if (state.status ==
                                              RatingStatus.success) {
                                            context.pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(state.message),
                                              ),
                                            );
                                          }
                                        },
                                        builder: (context, state) {
                                          return CompleteButton(
                                            function: () {
                                              if (reviewController
                                                  .text.isNotEmpty) {
                                                context
                                                    .read<RatingCubit>()
                                                    .addRating(
                                                        productId:
                                                            order.productId,
                                                        review: reviewController
                                                            .text,
                                                        rating: double.parse(
                                                            ratingController
                                                                .text),
                                                        orderId: order.id,
                                                        sellerId: order
                                                            .product.userId);
                                              }
                                            },
                                            isLoading: state.status ==
                                                RatingStatus.loading,
                                            text: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 20),
                                              child: Text(
                                                "Add Rating",
                                                style: GoogleFonts.inter(
                                                    fontSize: 1.8 *
                                                        SizeConfig
                                                            .heightMultiplier,
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
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.purple.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Text(
                            "Add Review",
                            style: GoogleFonts.inter(
                              fontSize: 1.5 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (DateTime.now().difference(order.updatedAt).inDays < 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        context.read<OrderCubit>().returnOrder(order: order);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.green.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Text(
                            "Return Item",
                            style: GoogleFonts.inter(
                              fontSize: 1.5 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          Gap(1 * SizeConfig.heightMultiplier),
          Text(
            "Created on ${DateFormat.yMMMMd().format(order.createdAt)} at ${DateFormat.jm().format(order.createdAt)}",
            style: GoogleFonts.inter(
                fontSize: 1.4 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500,
                color: black),
          ),
        ],
      ),
    );
  }
}
