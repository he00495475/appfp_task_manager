import 'package:flutter/foundation.dart';

class LoadingViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setIsLoading(bool isLoad) {
    _isLoading = isLoad;

    notifyListeners();
  }
}
