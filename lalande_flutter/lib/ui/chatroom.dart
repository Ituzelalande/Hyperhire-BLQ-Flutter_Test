import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/open/open_channel.dart';
import 'package:sendbird_sdk/core/message/base_message.dart';
import 'package:sendbird_sdk/params/message_list_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';


class ChatRoom extends StatelessWidget {

  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lalande Flutter Chat',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0e0d0d),
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatRoomScreen(),
    );
  }

}

class ChatRoomScreen extends StatefulWidget {

  const ChatRoomScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatRoomScreenState();
  }

}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  late OpenChannel _channel;
  final _userId = 'lalande';
  final List<BaseMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initSendbird();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lalande - 강남스팟',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xCBEAEAEA)),
          onPressed: () {
            Navigator.pop(context);
            SystemNavigator.pop();
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return {'새로 고치다', '출구'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.menu, color: Color(0xCBEAEAEA)),
            onSelected: (value) {
              switch (value) {
                case '새로 고치다':
                  _loadMessages();
                  break;
                case '출구':
                  Navigator.pop(context);
                  SystemNavigator.pop();
                  break;
              }
            },
          ),
        ],
        backgroundColor: const Color(0xFF0e0d0d),
      ),
      backgroundColor: const Color(0xFF0e0d0d),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            _messages.isNotEmpty
                ? Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessage(
                        message: _messages[index]
                    );
                  },
                ),
              ),
            )
                : const Expanded(child: Loader()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              color: Colors.black,
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.add, color: Color(0xFFF1EFEF)
                          )
                      ),
                      onTap: () {},
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                          border: Border.all(width: 0.6, color: const Color(0xFFC9C9C9)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: '안녕하세요',
                                  hintStyle: TextStyle(color: Color(0xFFF6F6F6)),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                                minLines: 1,
                                maxLines: 4,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFff2983),
                                borderRadius: BorderRadius.all(Radius.circular(24)
                                ),
                              ),
                              child: InkWell(
                                child: const Icon(Icons.arrow_upward, color: Color(0xFF171717)),
                                onTap: () => _handleSubmitted(_textController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initSendbird() async {
    try {
      SendbirdSdk(
        appId: "BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF",
        apiToken: "f93b05ff359245af400aa805bafd2a091a173064"
      );
      final user = await SendbirdSdk().connect(_userId,
          accessToken: "02de54411c3b107081cc75de3166aeebfb591af3"
      );
      if (kDebugMode) {
        print('Connected as ${user.userId}');
      }
      _joinChannel();
    } catch (e) {
      if (kDebugMode) {
        print('Sendbird connection error: $e');
      }
    }
  }

  Future<void> _joinChannel() async {
    try {
      _channel = await OpenChannel.getChannel("sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211");
      await _channel.enter();
      if (kDebugMode) {
        print('Channel joined');
      }
      _loadMessages();
    } catch (e) {
      if (kDebugMode) {
        print('Join channel error: $e');
      }
    }
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _messages.clear();
      });
      final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      final params = MessageListParams();
      params.reverse = true;
      final messages = await _channel.getMessagesByTimestamp(currentTimeMillis, params);
      setState(() {
        _messages.addAll(messages);

        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollToBottom();
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Load messages error: $e');
      }
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleSubmitted(String text) async {
    _textController.clear();

    final params = UserMessageParams(message: text);

    BaseMessage message = _channel.sendUserMessage(params, onCompleted: (message, error) {
      if (error != null) {
        if (kDebugMode) {
          print('Send message error: $e');
        }
        return;
      }

      if (mounted) {
        setState(() {
          _messages.insert(0, message);
        });
      }
    });

  }

}

class ChatMessage extends StatelessWidget {

  int read = 1;
  String? profileUrl = "";
  bool isSentByMe = false;
  final BaseMessage message;

  ChatMessage({super.key, required this.message}) {
    isSentByMe = message.sender?.userId == "lalande";
    if(message.sender != null) {
      if(message.sender?.profileUrl != null) {
        profileUrl = message.sender?.profileUrl;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: isSentByMe ? 30 : 0,),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isSentByMe)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(width: 2, color: const Color(0xFFff2983)),
                  ),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF000000),
                    radius: 20,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/user.png',
                      image: profileUrl!,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSentByMe ? const Color(0xFFff2983) : const Color(0xff232323),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isSentByMe ? 24 : 4),
                                topRight: Radius.circular(isSentByMe ? 4 : 24),
                                bottomLeft: const Radius.circular(24),
                                bottomRight: const Radius.circular(24)
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(!isSentByMe) Text(
                                message.sender != null ? message.sender!.nickname : '썸보내줘',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey
                                ),
                              ),
                              const SizedBox(height: 6,),
                              Text(
                                message.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(!isSentByMe) Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '$read분 전',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: isSentByMe ? 0 : 30,),
      ],
    );
  }
}

class Loader extends StatelessWidget {

  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          color: Color(0xFF44DE88),
          strokeWidth: 4,
        ),
      ),
    );
  }

}
