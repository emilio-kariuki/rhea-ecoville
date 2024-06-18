import 'package:ecoville/blocs/app/app_cubit.dart';
import 'package:ecoville/blocs/app/local_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _searchController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.grey[600],
                    )),
                    Gap(1 * SizeConfig.widthMultiplier),
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    cursorHeight: 15,
                    style: TextStyle(fontSize: 1.6 * SizeConfig.textMultiplier),
                    onFieldSubmitted: (value) {
                      _searchController.text = value;
                      context.push(Routes.searchResults,
                          extra: {'controller': _searchController});
                      context.read<AppCubit>().insertSearch(name: value);
                      _searchController.clear();
                      _focusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search on Ecoville',
                      hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 1.6 * SizeConfig.textMultiplier),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _focusNode.requestFocus();
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[600],
                    )),
                Gap(2 * SizeConfig.widthMultiplier),
                BlocBuilder<LocalCubit, LocalState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        IconContainer(
                            icon: AppImages.cart,
                            function: () => context.pushNamed(Routes.cart)),
                        if (state.cartItems.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xffF4521E),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                state.cartItems.length.toString(),
                                style: GoogleFonts.inter(
                                  color: darkGrey,
                                  fontSize: 1.3 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            Text(
              "Your recent searches",
              style: GoogleFonts.inter(
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
            Gap(1 * SizeConfig.heightMultiplier),
            BlocConsumer<AppCubit, AppState>(
              listener: (context, state) {
                if (state.status == AppStatus.success) {
                  context.read<AppCubit>().getSearchList();
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 35,
                      child: OutlinedButton(
                        onPressed: () {
                          _searchController.text = state.searches[index].name;
                          context.push(Routes.searchResults,
                              extra: {'controller': _searchController});
                        },
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: white,
                            foregroundColor: Colors.grey,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Gap(2 * SizeConfig.widthMultiplier),
                            Text(
                              state.searches[index].name,
                              style: GoogleFonts.inter(
                                  fontSize: 1.7 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state.searches.length,
                );
              },
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            GestureDetector(
              onTap: () => context.read<AppCubit>().clearSearch(),
              child: Text(
                "CLEAR SEARCHES",
                style: GoogleFonts.inter(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: red),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
