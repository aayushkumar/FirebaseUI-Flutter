import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/widgets.dart';

/// {@template ui.auth.auth_action}
/// An authentication action to perform.
/// {@endtemplate}
enum AuthAction {
  /// Performs user sign in
  signIn,

  /// Creates a new account with for a provided credential
  signUp,

  /// Links a provided credential with currently signed in user account
  link,
}

/// An abstract class that should be implemented by auth controllers of
/// respective auth providers.
///
/// See also:
/// * [EmailAuthController]
/// * [EmailLinkAuthController]
/// * [OAuthController]
/// * [PhoneAuthController]
/// * [UniversalEmailSignInController]
abstract class AuthController {
  /// Looks up an instance of controller of type T.
  /// This method should be called only inside widgets that have
  /// an [AuthFlowBuilder] as an ancestor.
  static T ofType<T extends AuthController>(BuildContext context) {
    final ctrl = context
        .dependOnInheritedWidgetOfExactType<AuthControllerProvider>()
        ?.ctrl;

    if (ctrl == null || ctrl is! T) {
      throw Exception(
        'No controller of type $T found. '
        'Make sure to wrap your code with AuthFlowBuilder<$T>',
      );
    }

    return ctrl;
  }

  /// {@macro ui.auth.auth_action}
  AuthAction get action;

  /// {@template ui.auth.auth_controller.auth}
  /// The [FirebaseAuth] instance used to perform authentication against.
  /// By default, [FirebaseAuth.instance] is used.
  /// {@endtemplate}
  FirebaseAuth get auth;

  /// {@template ui.auth.auth_controller.reset}
  /// Resets the controller to initial state.
  /// Usuall called when user cancels the authentication flow.
  /// {@endtemplate}
  void reset();
}

class AuthControllerProvider extends InheritedWidget {
  /// {@macro ui.auth.auth_action}
  final AuthAction action;

  /// An instance of controller to provide down the widget tree.
  final AuthController ctrl;

  const AuthControllerProvider({
    /// {@macro flutter.widgets.ProxyWidget.child}
    required Widget child,
    required this.action,
    required this.ctrl,
  }) : super(child: child);

  @override
  bool updateShouldNotify(AuthControllerProvider oldWidget) {
    return ctrl != oldWidget.ctrl || action != oldWidget.action;
  }
}
