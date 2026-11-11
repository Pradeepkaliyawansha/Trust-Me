import 'dart:async';

/// Lets the network layer tell the auth layer that the session is dead
/// (refresh token rejected) without a circular provider dependency.
class SessionEvents {
  final _controller = StreamController<void>.broadcast();

  Stream<void> get onExpired => _controller.stream;

  void notifyExpired() {
    if (!_controller.isClosed) _controller.add(null);
  }

  void dispose() => _controller.close();
}
