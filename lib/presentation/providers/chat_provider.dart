import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService.instance;

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
    if (!_supabase.isAuthenticated) return;
    try {
      final data = await _supabase.getChatSessions();
      _sessions = data.map((s) => ChatSessionEntity(
        id: s['id'],
        title: s['title'],
        messages: [],
        createdAt: DateTime.parse(s['created_at']),
        updatedAt: DateTime.parse(s['updated_at']),
      )).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> selectSession(String sessionId) async {
    _currentSessionId = sessionId;
    try {
      final data = await _supabase.getMessages(sessionId);
      _messages = data.map((m) => ChatMessageEntity(
        id: m['id'],
        content: m['content'],
        role: m['role'] == 'user' ? MessageRole.user : MessageRole.assistant,
        timestamp: DateTime.parse(m['created_at']),
        imagePath: m['image_url'],
      )).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createNewSession() async {
    try {
      final session = await _supabase.createChatSession();
      _currentSessionId = session['id'];
      _sessions.insert(0, ChatSessionEntity(
        id: session['id'],
        title: session['title'],
        messages: [],
        createdAt: DateTime.parse(session['created_at']),
        updatedAt: DateTime.parse(session['updated_at']),
      ));
      _messages = [];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendMessage(
    String content, {
    String? imagePath,
    String type = 'Indicator',
    String version = 'Pine Script v6',
  }) async {
    if (content.trim().isEmpty && imagePath == null) return;

    if (_currentSessionId == null) {
      await createNewSession();
    }

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
    _error = null;
    notifyListeners();

    try {
      await _supabase.sendMessage(
        sessionId: _currentSessionId!,
        role: 'user',
        content: content,
        imageUrl: imagePath,
      );

      final aiReply = await GeminiService.generatePineScript(
        prompt: content,
        type: type,
        version: version,
      );

      await _supabase.sendMessage(
        sessionId: _currentSessionId!,
        role: 'assistant',
        content: aiReply,
      );

      final aiMsg = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiReply,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMsg);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _supabase.deleteChatSession(sessionId);
      _sessions.removeWhere((s) => s.id == sessionId);
      if (_currentSessionId == sessionId) {
        _currentSessionId = null;
        _messages = [];
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void searchSessions(String query) {
    if (query.isEmpty) {
      _loadSessions();
    } else {
      _sessions = _sessions
          .where((s) => s.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }
}
