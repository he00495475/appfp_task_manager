import 'package:flutter/material.dart';

class TooltipHelper {
  static void showLoginSuccessfulMessage(BuildContext context, String message) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 10 * 8,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // 定时关闭
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
