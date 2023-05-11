import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:new_chat_app/app/blocs/message/message_bloc.dart' as message_bloc;
import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/app/presentation/screens/chat/local_widgets/bottom_widget.dart';
import 'package:new_chat_app/core/app_navigator/app_navigator.dart';
import 'package:new_chat_app/core/constants.dart';
import 'package:new_chat_app/services/logger.dart';
import 'package:new_chat_app/app/models/user.dart' as user_model;
import 'package:new_chat_app/app/models/message.dart' as message_model;

String randomString() {
  var random = Random.secure();
  var values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatScreen extends StatefulWidget {
  static const String route = 'chat-screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<message_bloc.MessageBloc>(context).add(const message_bloc.MessageRequested());
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();

  List<types.Message> convertMessage(List<message_model.Message?> messages) {
    List<types.Message> messages0 = [];

    for (final element in messages) {
      final message = types.TextMessage(text: element!.content, id: element.messageId, author: types.User(id: element.authorId));
      messages0.insert(messages.indexOf(element), message);
    }

    return messages0;
  }

  types.User convertUser(user_model.User user) {
    return types.User(id: user.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: const Text('Chat Room'),
      ),
      body: SafeArea(
        child: BlocConsumer<message_bloc.MessageBloc, message_bloc.MessageState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.status) {
              case message_bloc.MessageStatus.initial:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case message_bloc.MessageStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case message_bloc.MessageStatus.success:
                return Chat(
                  messages: convertMessage(state.messages),
                  onSendPressed: (p0) {},
                  user: convertUser(user_model.User.instance),
                  // sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                  showUserNames: true,
                  theme: const DefaultChatTheme(),
                  customBottomWidget: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: BottomWidget(
                      messageController: messageController,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final value = messageController.text;
                          logger.d(value);
                          //  final value = _formKey.currentState!.fields['message']!.value;
                          // final value = Map<String, dynamic>.of(_formKey.currentState!.value);

                          if (value.isNotEmpty) {
                            final message = types.PartialText(text: value);

                            BlocProvider.of<message_bloc.MessageBloc>(context, listen: false).add(
                              message_bloc.MessageSent(
                                  message: message_model.Message(
                                messageId: randomString(),
                                content: message.text,
                                authorId: User.instance.userId ?? '',
                                authorName: User.instance.username,
                                timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
                              )),
                            );
                          }
                        }
                        messageController.clear();
                      },
                    ),
                  ),
                );
              case message_bloc.MessageStatus.failure:
                return const Center(
                  child: Text(kGenericErrorMessage),
                );
            }
          },
        ),
      ),
    );
  }
}
