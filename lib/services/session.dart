import 'auth_service.dart';

/// Simple in-memory session to store the currently logged in user during app runtime.
class Session {
  Session._();

  static AuthUser? currentUser;
}
