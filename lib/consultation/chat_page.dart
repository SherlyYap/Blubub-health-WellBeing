import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/database/db_chat_helper.dart'; 

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

  void _addWelcomeMessage() async {
    final msg = types.TextMessage(
      author: _doctor,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text:
          "Halo, saya Dr. ${widget.doctorName}. Apa yang bisa saya bantu hari ini?",
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

  void _simulateDoctorReply(String userText) async {
    setState(() {
      _isTyping = true;
    });

    final typingDelay = Duration(milliseconds: 1500 + userText.length * 50);
    await Future.delayed(typingDelay);

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

    setState(() {
      _isTyping = false;
    });
  }

  String _generateReply(String userText) {
    final text = userText.toLowerCase();

    if (text.contains("hai") || text.contains("halo") || text.contains("hi")) {
      return "Hai juga! Gimana kabarmu hari ini? Kalau lagi ngerasa gak enak badan atau pikiran, boleh banget cerita ke aku ya.";
    } else if (text.contains("pagi")) {
      return "Selamat pagi! Ada keluhan atau hal yang ingin dibicarakan hari ini?";
    } else if (text.contains("siang")) {
      return "Selamat siang! Ada yang bisa saya bantu?";
    } else if (text.contains("sore")) {
      return "Selamat sore! Ceritain ke aku ya, gimana harimu?";
    } else if (text.contains("malam")) {
      return "Selamat malam! Sebelum tidur, boleh cerita sedikit biar pikiran lebih tenang.";
    } else if (text.contains("terima kasih") || text.contains("makasih")) {
      return "Sama-sama~ Senang bisa bantu kamu! Kalau masih ada yang mau ditanyain, jangan sungkan ya 😊";
    } else if (text.contains("cerita")) {
      return "Boleh banget! Ceritain aja, aku siap dengerin dan bantu sebisaku.";
    } else if (text.contains("cemas")) {
      return "Wajar kok ngerasa cemas. Coba atur napas pelan-pelan, tenangkan diri dulu. Ceritain ke aku biar kita bisa cari penyebabnya bareng.";
    } else if (text.contains("stres") || text.contains("stress")) {
      return "Stres bisa datang dari banyak hal. Coba luangkan waktu buat diri sendiri dulu, kayak jalan santai, meditasi, atau denger musik yang kamu suka.";
    } else if (text.contains("sedih") || text.contains("kecewa")) {
      return "Sedih itu manusiawi kok. Tapi jangan lupa buat jaga diri ya. Kadang istirahat atau ngobrol sama orang dekat bisa bantu sedikit lega.";
    } else if (text.contains("tidur")) {
      return "Masalah tidur sering banget terjadi. Coba hindari HP atau kopi sebelum tidur, dan biasakan jam tidur yang teratur ya.";
    } else if (text.contains("capek") || text.contains("lelah")) {
      return "Capek ya? Kadang tubuh juga butuh istirahat sejenak. Jangan lupa minum air putih dan makan teratur juga ya.";
    } else if (text.contains("marah")) {
      return "Kalau lagi marah, gak apa-apa kok. Tapi coba kasih waktu buat tenang dulu. Nulis perasaanmu di catatan bisa bantu loh.";
    } else if (text.contains("sendiri") || text.contains("kesepian")) {
      return "Perasaan sendiri itu berat ya. Coba hubungi teman atau keluarga, atau keluar cari suasana baru, kadang bisa bantu perasaanmu lebih baik.";
    } else if (text.contains("tidak baik") || text.contains("kurang baik")) {
      return "Lagi gak enak badan ya? Mau cerita sedikit soal apa yang kamu rasain biar aku bisa bantu?";
    } else {
      return "Hmm, aku paham kok. Ceritain lebih lanjut ya biar aku bisa bantu lebih banyak 😊";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Konsultasi dengan Dr. ${widget.doctorName}",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff0D273D),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<types.Message>>(
              stream: _messageController.stream,
              initialData: _messages,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return Chat(
                  messages: messages,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Dr. ${widget.doctorName} sedang mengetik...",
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
