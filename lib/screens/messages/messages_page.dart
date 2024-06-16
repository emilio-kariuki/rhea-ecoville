import 'package:ecoville/blocs/app/message_cubit.dart';
import 'package:ecoville/shared/input_field.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(2 * SizeConfig.widthMultiplier),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 20,
                              )),
                          Gap(1 * SizeConfig.widthMultiplier),
                          Text(
                            'Messages',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(2 * SizeConfig.widthMultiplier),
                      InputField(
                          controller: _searchController,
                          borderColor: Colors.grey[300]!,
                          borderRadius: 10,
                          fillColor: lightGrey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please such a user';
                            }
                            return null;
                          },
                          hintText: 'Search user'),
                      Gap(2 * SizeConfig.widthMultiplier),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Your Messages',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BlocBuilder<MessageCubit, MessageState>(
                      bloc: context.read<MessageCubit>()..getConversations(),
                      buildWhen: (previous, current) => previous.conversations != current.conversations,
                      builder: (context, state) {
                        if (state.status == MessageStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.status == MessageStatus.success) {
                          return ListView.builder(
                            itemCount: state.conversations.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final conversation = state.conversations[index];
                              return GestureDetector(
                                onTap: () => context.push(
                                    '/messages/chat/${conversation.sellerId}/${conversation.id}'),
                                child: OutlinedButton(
                                  onPressed: () => context.push(
                                      '/messages/chat/${conversation.sellerId}/${conversation.id}'),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor: lightGrey,
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      NetworkImageContainer(
                                        imageUrl: conversation.user?.image ??
                                            AppImages.defaultImage,
                                        height: size.height * 0.07,
                                        width: size.height * 0.05,
                                        isCirlce: true,
                                      ),
                                      Gap(2 * SizeConfig.widthMultiplier),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            conversation.user?.name ?? 'Unknown',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                height: 1),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.6,
                                            child: Text(
                                              conversation.message,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[600],
                                                  height: 1.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        conversation.createdAt.toString().timeAgo(),
                                        style: GoogleFonts.quicksand(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('Failed to fetch messages'),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
