import 'package:ecoville/blocs/app/address_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            "Addresses",
            style: GoogleFonts.inter(
                fontSize: 2.2 * SizeConfig.heightMultiplier,
                fontWeight: FontWeight.w600,
                color: black),
          ),
          actions: [
            IconContainer(
                icon: AppImages.add,
                function: () => context.pushNamed(Routes.addAddress)),
            Gap(1 * SizeConfig.widthMultiplier),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
              if (state.status == AddressStatus.added) {
                context.read<AddressCubit>().getAddresses();
              }
            },
            builder: (context, state) {
              if (state.status == AddressStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.separated(
                  itemCount: state.addresses.length,
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return OutlinedButton(
                      onPressed:  () =>
                        context.pushNamed(Routes.editAddress, extra: {
                      "id": address.id,
                    }),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        foregroundColor: white,
                        side: BorderSide.none,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.name,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.5 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                              Text(
                                address.addressLine1,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.6 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w400,
                                    color: black),
                              ),
                              Text(
                                address.addressLine2,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.6 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w400,
                                    color: black),
                              ),
                              Text(
                                address.city,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.6 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w400,
                                    color: black),
                              ),
                              Text(
                                address.country,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.6 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w400,
                                    color: black),
                              ),
                              Text(
                                address.phone,
                                style: GoogleFonts.inter(
                                    fontSize:
                                        1.6 * SizeConfig.heightMultiplier,
                                    fontWeight: FontWeight.w400,
                                    color: black),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconContainer(
                              icon: AppImages.right, function: () {})
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey[300],
                      thickness: 0.5,
                      height: 20,
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
