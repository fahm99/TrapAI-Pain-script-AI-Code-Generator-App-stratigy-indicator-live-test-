import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._();
  SupabaseService._();

  final SupabaseClient _client = Supabase.instance.client;
  SupabaseClient get client => _client;

  // =====================================================
  // AUTH
  // =====================================================
  
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // =====================================================
  // PROFILES
  // =====================================================

  Future<Map<String, dynamic>?> getProfile() async {
    if (currentUser == null) return null;
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', currentUser!.id)
        .single();
    return response;
  }

  Future<void> updateProfile({String? fullName, String? avatarUrl}) async {
    if (currentUser == null) return;
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    await _client.from('profiles').update(updates).eq('id', currentUser!.id);
  }

  // =====================================================
  // CHAT SESSIONS
  // =====================================================

  Future<List<Map<String, dynamic>>> getChatSessions() async {
    if (currentUser == null) return [];
    final response = await _client
        .from('chat_sessions')
        .select()
        .eq('user_id', currentUser!.id)
        .order('updated_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createChatSession({String title = 'New Chat'}) async {
    if (currentUser == null) throw Exception('Not authenticated');
    final response = await _client
        .from('chat_sessions')
        .insert({
          'user_id': currentUser!.id,
          'title': title,
        })
        .select()
        .single();
    return response;
  }

  Future<void> updateChatSession(String sessionId, {String? title}) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    await _client.from('chat_sessions').update(updates).eq('id', sessionId);
  }

  Future<void> deleteChatSession(String sessionId) async {
    await _client.from('chat_sessions').delete().eq('id', sessionId);
  }

  // =====================================================
  // CHAT MESSAGES
  // =====================================================

  Future<List<Map<String, dynamic>>> getMessages(String sessionId) async {
    final response = await _client
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String role,
    required String content,
    String? imageUrl,
  }) async {
    final response = await _client
        .from('chat_messages')
        .insert({
          'session_id': sessionId,
          'role': role,
          'content': content,
          'image_url': imageUrl,
        })
        .select()
        .single();
    return response;
  }

  // =====================================================
  // PINE SCRIPTS
  // =====================================================

  Future<List<Map<String, dynamic>>> getPineScripts() async {
    if (currentUser == null) return [];
    final response = await _client
        .from('pine_scripts')
        .select()
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> savePineScript({
    required String filename,
    required String content,
    required String version,
    required String scriptType,
    String? sessionId,
  }) async {
    if (currentUser == null) throw Exception('Not authenticated');
    final response = await _client
        .from('pine_scripts')
        .insert({
          'user_id': currentUser!.id,
          'session_id': sessionId,
          'filename': filename,
          'content': content,
          'version': version,
          'script_type': scriptType,
        })
        .select()
        .single();
    return response;
  }

  Future<void> deletePineScript(String scriptId) async {
    await _client.from('pine_scripts').delete().eq('id', scriptId);
  }

  Future<void> toggleFavorite(String scriptId, bool isFavorite) async {
    await _client
        .from('pine_scripts')
        .update({'is_favorite': isFavorite})
        .eq('id', scriptId);
  }

  // =====================================================
  // USER SETTINGS
  // =====================================================

  Future<Map<String, dynamic>?> getSettings() async {
    if (currentUser == null) return null;
    final response = await _client
        .from('user_settings')
        .select()
        .eq('user_id', currentUser!.id)
        .single();
    return response;
  }

  Future<void> updateSettings({
    String? theme,
    String? language,
    bool? notificationsEnabled,
    String? defaultScriptVersion,
    String? defaultScriptType,
  }) async {
    if (currentUser == null) return;
    final updates = <String, dynamic>{};
    if (theme != null) updates['theme'] = theme;
    if (language != null) updates['language'] = language;
    if (notificationsEnabled != null) updates['notifications_enabled'] = notificationsEnabled;
    if (defaultScriptVersion != null) updates['default_script_version'] = defaultScriptVersion;
    if (defaultScriptType != null) updates['default_script_type'] = defaultScriptType;
    await _client.from('user_settings').update(updates).eq('user_id', currentUser!.id);
  }
}
