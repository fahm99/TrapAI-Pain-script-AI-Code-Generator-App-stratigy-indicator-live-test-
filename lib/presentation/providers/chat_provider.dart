import 'package:flutter/foundation.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../data/datasources/mock_datasource.dart';

class ChatProvider extends ChangeNotifier {
  final MockDataSource _dataSource = MockDataSource.instance;

  List<ChatSessionEntity> _allSessions = [];
  List<ChatSessionEntity> _sessions = [];
  List<ChatMessageEntity> _messages = [];
  String? _currentSessionId;
  bool _isLoading = false;
  String? _error;

  List<ChatSessionEntity> get sessions => _sessions;
  List<ChatMessageEntity> get messages => _messages;
  String? get currentSessionId => _currentSessionId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatProvider() {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    _allSessions = await _dataSource.getChatSessions();
    _sessions = List.from(_allSessions);
    notifyListeners();
  }

  void selectSession(String sessionId) {
    _currentSessionId = sessionId;
    final session = _allSessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => _allSessions.first,
    );
    _messages = List.from(session.messages);
    notifyListeners();
  }

  void createNewSession() {
    _currentSessionId = null;
    _messages = [];
    notifyListeners();
  }

  Future<void> sendMessage(String content, {String? imagePath}) async {
    if (content.trim().isEmpty && imagePath == null) return;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );
    _messages.add(userMsg);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    final aiMsg = await _dataSource.sendMessage(content, imagePath: imagePath);
    _messages.add(aiMsg);
    _isLoading = false;
    notifyListeners();
  }

  void deleteSession(String sessionId) {
    _allSessions.removeWhere((s) => s.id == sessionId);
    _sessions.removeWhere((s) => s.id == sessionId);
    if (_currentSessionId == sessionId) {
      _currentSessionId = null;
      _messages = [];
    }
    notifyListeners();
  }

  void searchSessions(String query) {
    if (query.isEmpty) {
      _sessions = List.from(_allSessions);
    } else {
      _sessions = _allSessions
          .where((s) => s.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
