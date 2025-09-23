import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String doctorName;
  const ChatPage({super.key, required this.doctorName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user');
  final types.User _doctor = const types.User(id: 'doctor');

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final msg = types.TextMessage(
      author: _doctor,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "Halo, saya Dr. ${widget.doctorName}. Apa yang bisa saya bantu hari ini?",
    );

    setState(() {
      _messages.insert(0, msg);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    _simulateDoctorReply(message.text);
  }

  void _simulateDoctorReply(String userText) {
    Future.delayed(const Duration(seconds: 1), () {
      final reply = types.TextMessage(
        author: _doctor,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: _generateReply(userText),
      );

      setState(() {
        _messages.insert(0, reply);
      });
    });
  }

  String _generateReply(String userText) {
    if (userText.toLowerCase().contains("cemas")) {
      return "Rasa cemas itu wajar. Coba tarik napas perlahan dan ceritakan lebih banyak ya.";
    } else if (userText.toLowerCase().contains("tidur")) {
      return "Masalah tidur bisa disebabkan stres atau pola hidup. Kamu tidur jam berapa biasanya?";
    } else {
      return "Saya mengerti. Terima kasih sudah berbagi, mari kita bahas lebih lanjut.";
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
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          primaryColor: Color(0xff0D273D),
          inputBackgroundColor: Colors.white,
          inputTextColor: Colors.black,
        ),
      ),
    );
  }
}
