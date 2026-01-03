import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Toast types for different styles
enum ToastType { success, error, warning, info }

/// Toast data model
class ToastData {
  final String id;
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onUndo;
  final String? undoLabel;
  final IconData? icon;

  ToastData({
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 4),
    this.onUndo,
    this.undoLabel,
    this.icon,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}

/// Global toast controller
class ToastController {
  static final ToastController _instance = ToastController._internal();
  factory ToastController() => _instance;
  ToastController._internal();

  final _toastStreamController = StreamController<ToastAction>.broadcast();
  Stream<ToastAction> get stream => _toastStreamController.stream;

  void show(ToastData toast) {
    _toastStreamController.add(ToastAction.add(toast));
  }

  void dismiss(String id) {
    _toastStreamController.add(ToastAction.remove(id));
  }

  void dismissAll() {
    _toastStreamController.add(ToastAction.clear());
  }

  /// Quick success toast
  void success(String message, {VoidCallback? onUndo, String? undoLabel}) {
    show(ToastData(
      message: message,
      type: ToastType.success,
      onUndo: onUndo,
      undoLabel: undoLabel ?? 'Hoàn tác',
      icon: Icons.check_circle_rounded,
    ));
  }

  /// Quick error toast
  void error(String message) {
    show(ToastData(
      message: message,
      type: ToastType.error,
      duration: const Duration(seconds: 5),
      icon: Icons.error_rounded,
    ));
  }

  /// Quick warning toast
  void warning(String message) {
    show(ToastData(
      message: message,
      type: ToastType.warning,
      icon: Icons.warning_rounded,
    ));
  }

  /// Quick info toast
  void info(String message) {
    show(ToastData(
      message: message,
      type: ToastType.info,
      icon: Icons.info_rounded,
    ));
  }

  void dispose() {
    _toastStreamController.close();
  }
}

/// Toast action types
enum ToastActionType { add, remove, clear }

class ToastAction {
  final ToastActionType type;
  final ToastData? toast;
  final String? id;

  ToastAction.add(this.toast) : type = ToastActionType.add, id = null;
  ToastAction.remove(this.id) : type = ToastActionType.remove, toast = null;
  ToastAction.clear() : type = ToastActionType.clear, toast = null, id = null;
}

/// Toast overlay widget - wrap your app with this
class ToastOverlay extends StatefulWidget {
  final Widget child;

  const ToastOverlay({super.key, required this.child});

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  final List<ToastData> _toasts = [];
  final Map<String, Timer> _timers = {};
  late StreamSubscription<ToastAction> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = ToastController().stream.listen(_handleAction);
  }

  @override
  void dispose() {
    _subscription.cancel();
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _handleAction(ToastAction action) {
    switch (action.type) {
      case ToastActionType.add:
        _addToast(action.toast!);
        break;
      case ToastActionType.remove:
        _removeToast(action.id!);
        break;
      case ToastActionType.clear:
        _clearAll();
        break;
    }
  }

  void _addToast(ToastData toast) {
    setState(() {
      // Limit to 3 toasts max
      if (_toasts.length >= 3) {
        final oldest = _toasts.first;
        _timers[oldest.id]?.cancel();
        _timers.remove(oldest.id);
        _toasts.removeAt(0);
      }
      _toasts.add(toast);
    });

    // Auto dismiss timer
    _timers[toast.id] = Timer(toast.duration, () {
      _removeToast(toast.id);
    });
  }

  void _removeToast(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    setState(() {
      _toasts.removeWhere((t) => t.id == id);
    });
  }

  void _clearAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    setState(() {
      _toasts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Toast stack
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Column(
            children: _toasts.map((toast) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ToastWidget(
                  key: ValueKey(toast.id),
                  toast: toast,
                  onDismiss: () => _removeToast(toast.id),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Individual toast widget with animations
class _ToastWidget extends StatefulWidget {
  final ToastData toast;
  final VoidCallback onDismiss;

  const _ToastWidget({
    super.key,
    required this.toast,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  double _dragOffset = 0;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  Color _getBackgroundColor() {
    switch (widget.toast.type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.danger;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.hydroEnd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.delta.dx;
          });
        },
        onHorizontalDragEnd: (details) {
          if (_dragOffset.abs() > 80) {
            HapticFeedback.lightImpact();
            _dismiss();
          } else {
            setState(() {
              _dragOffset = 0;
            });
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < -5) {
            HapticFeedback.lightImpact();
            _dismiss();
          }
        },
        child: Transform.translate(
          offset: Offset(_dragOffset * 0.5, 0),
          child: Opacity(
            opacity: (1 - (_dragOffset.abs() / 200)).clamp(0.3, 1.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getBackgroundColor().withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (widget.toast.icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.toast.icon,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      widget.toast.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (widget.toast.onUndo != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        widget.toast.onUndo!();
                        _dismiss();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.toast.undoLabel ?? 'Hoàn tác',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Global toast helper (convenience)
final toast = ToastController();


