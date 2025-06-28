import 'package:flutter/material.dart';
import '../components/loading_dialog.dart';

class LoadingService {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show(BuildContext context) {
    if (_isShowing) return;
    
    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => const LoadingDialog._(),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    if (!_isShowing || _overlayEntry == null) return;
    
    _overlayEntry!.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  static bool get isShowing => _isShowing;
}