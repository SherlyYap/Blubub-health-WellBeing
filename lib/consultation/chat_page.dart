import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project/database/db_chat_helper.dart';
import 'package:project/localization/app_localizations.dart';

class ChatPage extends StatefulWidget {
  final String doctorName;
  const ChatPage({super.key, required this.doctorName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = StreamController<List<types.Message>>.broadcast();
  final ScrollController _scrollController = ScrollController();
  List<types.Message> _messages = [];
  bool _isTyping = false;

  final types.User _user = const types.User(id: 'user');
  final types.User _doctor = const types.User(id: 'doctor');

  @override
  void initState() {
    super.initState();
    _loadMessagesFromDb();
  }

  @override
  void dispose() {
    _messageController.close();
    _scrollController.dispose();
    super.dispose();
  }

  // ================= LOAD CHAT =================
  Future<void> _loadMessagesFromDb() async {
    final chatData = await DBChatHelper.getMessages(widget.doctorName);

    setState(() {
      _messages = chatData.map((msg) {
        final author = msg['author'] == 'user' ? _user : _doctor;
        return types.TextMessage(
          author: author,
          createdAt: msg['createdAt'],
          id: msg['id'],
          text: msg['text'],
        );
      }).toList();
    });

    if (_messages.isEmpty) {
      _addWelcomeMessage();
    } else {
      _updateMessages();
    }
  }

  // ================= WELCOME MESSAGE =================
  void _addWelcomeMessage() async {
    final loc = AppLocalizations.of(context);

    final msg = types.TextMessage(
      author: _doctor,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: loc
          .translate('chat_welcome')
          .replaceAll('{name}', widget.doctorName),
    );

    _messages.insert(0, msg);
    _updateMessages();

    await DBChatHelper.insertMessage(
      widget.doctorName,
      msg.id,
      msg.text,
      'doctor',
      msg.createdAt!,
    );
  }

  // ================= UPDATE STREAM =================
  void _updateMessages() {
    if (!_messageController.isClosed) {
      _messageController.add(List.from(_messages));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ================= SEND MESSAGE =================
  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _messages.insert(0, textMessage);
    _updateMessages();

    await DBChatHelper.insertMessage(
      widget.doctorName,
      textMessage.id,
      textMessage.text,
      'user',
      textMessage.createdAt!,
    );

    _simulateDoctorReply(message.text);
  }

  // ================= DOCTOR REPLY =================
  void _simulateDoctorReply(String userText) async {
    setState(() => _isTyping = true);

    final delay = Duration(milliseconds: 1500 + userText.length * 50);
    await Future.delayed(delay);

    final reply = types.TextMessage(
      author: _doctor,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: _generateReply(userText),
    );

    _messages.insert(0, reply);
    _updateMessages();

    await DBChatHelper.insertMessage(
      widget.doctorName,
      reply.id,
      reply.text,
      'doctor',
      reply.createdAt!,
    );

    setState(() => _isTyping = false);
  }

  // ================= REPLY LOGIC =================
  String _generateReply(String userText) {
    final loc = AppLocalizations.of(context);
    final text = userText.toLowerCase();

    if (text.contains("hai") || text.contains("halo") || text.contains("hi")) {
      return loc.translate('reply_greeting');
    } else if (text.contains("pagi")) {
      return loc.translate('reply_morning');
    } else if (text.contains("siang")) {
      return loc.translate('reply_afternoon');
    } else if (text.contains("sore")) {
      return loc.translate('reply_evening');
    } else if (text.contains("malam")) {
      return loc.translate('reply_night');
    } else if (text.contains("terima kasih") || text.contains("makasih")) {
      return loc.translate('reply_thanks');
    } else if (text.contains("cerita")) {
      return loc.translate('reply_story');
    } else if (text.contains("cemas")) {
      return loc.translate('reply_anxious');
    } else if (text.contains("stres") || text.contains("stress")) {
      return loc.translate('reply_stress');
    } else if (text.contains("sedih") || text.contains("kecewa")) {
      return loc.translate('reply_sad');
    } else if (text.contains("tidur")) {
      return loc.translate('reply_sleep');
    } else if (text.contains("capek") || text.contains("lelah")) {
      return loc.translate('reply_tired');
    } else if (text.contains("marah")) {
      return loc.translate('reply_angry');
    } else if (text.contains("sendiri") || text.contains("kesepian")) {
      return loc.translate('reply_lonely');
    } else if (text.contains("tidak baik") || text.contains("kurang baik")) {
      return loc.translate('reply_unwell');
    } else {
      return loc.translate('reply_default');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0D273D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.translate('chat_title')
              .replaceAll('{name}', widget.doctorName),
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<types.Message>>(
              stream: _messageController.stream,
              initialData: _messages,
              builder: (context, snapshot) {
                return Chat(
                  messages: snapshot.data ?? [],
                  onSendPressed: _handleSendPressed,
                  user: _user,
                  theme: const DefaultChatTheme(
                    primaryColor: Color(0xff0D273D),
                    inputBackgroundColor: Colors.white,
                    inputTextColor: Colors.black,
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loc.translate('typing_indicator')
                          .replaceAll('{name}', widget.doctorName),
                      style: GoogleFonts.nunito(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
