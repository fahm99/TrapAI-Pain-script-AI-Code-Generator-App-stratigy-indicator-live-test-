import 'package:flutter/material.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;

  ChatProvider(this._repository);

  List<ChatSessionEntity> _sessions = [];
  ChatSessionEntity? _currentSession;
  List<ChatMessageEntity> _messages = [];
  bool _isLoading = false;
  String _currentMode = 'Indicator';
  String _currentVersion = 'v6';
  String? _error;

  List<ChatSessionEntity> get sessions => _sessions;
  ChatSessionEntity? get currentSession => _currentSession;
  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  String get currentMode => _currentMode;
  String get currentVersion => _currentVersion;
  String? get error => _error;

  void setMode(String mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setVersion(String version) {
    _currentVersion = version;
    notifyListeners();
  }

  Future<void> loadSessions() async {
    _sessions = await _repository.getChatSessions();
    notifyListeners();
  }

  Future<void> sendMessage(String content, {String? imagePath}) async {
    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final sessionId = _currentSession?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final aiMessage = await _repository.sendMessage(sessionId, content, imagePath: imagePath);
      _messages.add(aiMessage);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _currentSession = null;
    notifyListeners();
  }
}
