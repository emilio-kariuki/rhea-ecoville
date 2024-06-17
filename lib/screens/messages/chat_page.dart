import 'package:ecoville/blocs/app/message_cubit.dart';
import 'package:ecoville/blocs/app/user_cubit.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/shared/network_image_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:ecoville/utilities/utilities.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.conversationId, required this.sellerId});
  final String conversationId;
  final String sellerId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String get conversationId => widget.conversationId;
  String get seller => widget.sellerId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffEFEAE2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: BlocProvider(
          create: (context) => UserCubit()..getUserById(id: seller),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                      )),
                  Gap(1 * SizeConfig.widthMultiplier),
                  NetworkImageContainer(
                    imageUrl: state.user?.image ?? AppImages.defaultImage,
                    height: size.height * 0.05,
                    width: size.height * 0.04,
                    isCirlce: true,
                  ),
                  Gap(1 * SizeConfig.widthMultiplier),
                  Text(state.user?.name ?? 'Seller',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              );
            },
          ),
        ),
        actions: [
          IconContainer(icon: AppImages.more, function: () {}),
          Gap(1 * SizeConfig.widthMultiplier)
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<MessageCubit, MessageState>(
              bloc: context.read<MessageCubit>()
                ..getMessages(conversationId: conversationId),
              buildWhen: (previous, current) =>
                  current.messages != previous.messages,
              builder: (context, state) {
                supabase
                    .channel('public:$TABLE_MESSAGE')
                    .onPostgresChanges(
                        event: PostgresChangeEvent.all,
                        schema: 'public',
                        table: TABLE_MESSAGE,
                        filter: PostgresChangeFilter(
                          type: PostgresChangeFilterType.eq,
                          column: 'conversationsId',
                          value: conversationId,
                        ),
                        callback: (payload) async {
                          context
                              .read<MessageCubit>()
                              .getMessages(conversationId: conversationId);
                          await supabase.from(TABLE_CONVERSATIONS).update({
                            'message': payload.newRecord['message'],
                          }).eq('id', conversationId);
                        })
                    .subscribe();
                if (state.status == MessageStatus.loading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state.status == MessageStatus.error) {
                  return const Center(
                    child: Text('Error fetching messages'),
                  );
                } else {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      child: ListView.separated(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          return Messages(
                            message: msg.message,
                            isUser: msg.userId == supabase.auth.currentUser!.id,
                            date: msg.createdAt.toString(),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.send,
                          maxLines: 8,
                          minLines: 1,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                          decoration: InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              fillColor: Colors.grey[200],
                              hintText: 'Type your message here...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10)),
                          onFieldSubmitted: (value) {
                            context.read<MessageCubit>().sendMessage(
                                message: _messageController.text,
                                sellerId: seller,
                                conversationId: conversationId);
                            _messageController.clear();
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent +
                                    400,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                              );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<MessageCubit>().sendMessage(
                              message: _messageController.text,
                              sellerId: seller,
                              conversationId: conversationId);
                          _messageController.clear();
                          _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                              );
                        }, // function to call the API with user prompt
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.send),
                        iconSize: 22,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final String message;
  final bool isUser;
  final String date;

  const Messages(
      {super.key,
      required this.message,
      required this.isUser,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isUser ? 0 : 30, left: isUser ? 30 : 0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isUser ? const Color(0xff05A582) : Colors.white,
            borderRadius: isUser
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(4))
                : const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(4),
                    bottomRight: Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    letterSpacing: 0.3,
                    height: 1.2),
              ),
              Text(
                DateFormat('hh:mm a').format(DateTime.parse(date)),
                style: TextStyle(
                  color: isUser ? Colors.grey[300] : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
