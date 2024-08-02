import 'package:ecoville/blocs/app/bid_cubit.dart';
import 'package:ecoville/utilities/packages.dart';

class BiddingPage extends StatefulWidget {
  const  BiddingPage({super.key, required this.productId});

  final String productId;

  @override
  State<BiddingPage> createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  final _priceController = TextEditingController();

  final FocusNode _priceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _priceFocus.requestFocus();
  }

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
            "Place Your Bids",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                BlocProvider(
                  create: (context) => BidCubit(),
                  child: Builder(builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Place Your Bids",
                          style: GoogleFonts.inter(
                              fontSize: 1.5 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w600,
                              color: green),
                        ),
                        const Gap(2),
                        Text(
                          "By placing a bid, you agree to pay the amount if you win the auction",
                          style: GoogleFonts.inter(
                              fontSize: 1.4 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w600,
                              color: green),
                        ),

                        const Gap(2),
                        TextFormField(
                          focusNode: _priceFocus,
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter your bid price",
                            hintStyle: GoogleFonts.inter(
                                fontSize: 1.5 * SizeConfig.heightMultiplier,
                                fontWeight: FontWeight.w400,
                                color: darkGrey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: grey.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                        const Gap(2),
                        BlocConsumer<BidCubit, BidState>(
                          listener: (context, state) {
                            if (state.status == BidStatus.success) {
                              context.pop();
                            }
                            if (state.status == BidStatus.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<BidCubit>().createBid(
                                    productId: widget.productId,
                                    price: int.parse(_priceController.text));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: state.status == BidStatus.loading
                                  ?  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Place Bid",
                                      style: GoogleFonts.inter(
                                          fontSize: 1.5 * SizeConfig.heightMultiplier,
                                          fontWeight: FontWeight.w600,
                                          color: white),
                                    ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            )
          ),
        ));
  }
}
