import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  Future<bool> get isOnline async =>
      _hasConnection(await _connectivity.checkConnectivity());

  Stream<bool> get onlineStream async* {
    yield await isOnline;
    yield* _connectivity.onConnectivityChanged.map(_hasConnection).distinct();
  }

  void dispose() {}
}
