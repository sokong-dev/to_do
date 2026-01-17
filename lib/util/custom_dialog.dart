import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../image_path/icon_app.dart';

enum DialogType { warning, success, info }

class CustomShowDialog {
  // Delete Account Dialog (Warning)
  static Future<bool?> showWarning({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? cancelText,
    String? confirmText,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    DialogType type = DialogType.warning,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: CustomDialogContent(
            type: type,
            title: title ?? "Are you sure you want to delete your account?",
            subtitle:
                subtitle ??
                "This action is permanent and cannot be undone. All your data will be removed.",
            primaryButtonText: confirmText ?? "delete".tr,
            secondaryButtonText: cancelText ?? "cancel".tr,
            onPrimaryPressed:
                onConfirm ?? () => Navigator.of(context).pop(true),
            onSecondaryPressed:
                onCancel ?? () => Navigator.of(context).pop(false),
            showSecondaryButton: true,
          ),
        );
      },
    );
  }

  // Success Dialog
  static Future<bool?> showSuccessDialog({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onPressed,
    bool showSecondaryButton = false,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    int? autoCloseDuration,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: CustomDialogContent(
            type: DialogType.success,
            title: title ?? "Success!",
            subtitle:
                subtitle ?? "Your action has been completed successfully.",
            primaryButtonText: buttonText ?? "Continue",
            secondaryButtonText: secondaryButtonText ?? "Cancel",
            onPrimaryPressed:
                onPressed ?? () => Navigator.of(context).pop(true),
            onSecondaryPressed:
                onSecondaryPressed ?? () => Navigator.of(context).pop(false),
            showSecondaryButton: showSecondaryButton,
            autoCloseDuration: autoCloseDuration,
          ),
        );
      },
    );
  }

  // Warning Dialog
  static Future<bool?> showWarningDialog({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showSecondaryButton = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: CustomDialogContent(
            type: DialogType.warning,
            title: title ?? "Warning!",
            subtitle:
                subtitle ?? "Please review your action before proceeding.",
            primaryButtonText: confirmText ?? "Proceed",
            secondaryButtonText: cancelText ?? "Cancel",
            onPrimaryPressed:
                onConfirm ?? () => Navigator.of(context).pop(true),
            onSecondaryPressed:
                onCancel ?? () => Navigator.of(context).pop(false),
            showSecondaryButton: showSecondaryButton,
          ),
        );
      },
    );
  }

  // Info Dialog
  static Future<bool?> showInfoDialog({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? buttonText,
    VoidCallback? onPressed,
    bool showSecondaryButton = false,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: CustomDialogContent(
            type: DialogType.info,
            title: title ?? "Information",
            subtitle: subtitle ?? "Here's some important information for you.",
            primaryButtonText: buttonText ?? "Got it",
            secondaryButtonText: secondaryButtonText ?? "Cancel",
            onPrimaryPressed:
                onPressed ?? () => Navigator.of(context).pop(true),
            onSecondaryPressed:
                onSecondaryPressed ?? () => Navigator.of(context).pop(false),
            showSecondaryButton: showSecondaryButton,
          ),
        );
      },
    );
  }
}

class CustomDialogContent extends StatefulWidget {
  final DialogType type;
  final String title;
  final String subtitle;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final bool showSecondaryButton;
  final int? autoCloseDuration;

  const CustomDialogContent({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.showSecondaryButton = true,
    this.autoCloseDuration,
  });

  @override
  State<CustomDialogContent> createState() => _CustomDialogContentState();
}

class _CustomDialogContentState extends State<CustomDialogContent>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int? _remainingSeconds;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    if (widget.autoCloseDuration != null) {
      _remainingSeconds = widget.autoCloseDuration;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == null) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds! > 0) {
          _remainingSeconds = _remainingSeconds! - 1;
        } else {
          timer.cancel();
          widget.onPrimaryPressed();
        }
      });
    });
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      setState(() {
        _timer?.cancel();
        _remainingSeconds = null;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _cancelTimer(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with animation
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
                    ),
                  ),
                  child: SvgPicture.asset(
                    _getIconPath(),
                    height: 44,
                    width: 44,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // Buttons
                widget.showSecondaryButton
                    ? Row(
                        children: [
                          // Secondary Button
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: TextButton(
                                onPressed: widget.onSecondaryPressed,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    side: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  widget.secondaryButtonText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Primary Button
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: widget.onPrimaryPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getPrimaryButtonColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 4,
                                ),
                                child: Text(
                                  _getPrimaryButtonText(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: widget.onPrimaryPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getPrimaryButtonColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            _getPrimaryButtonText(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPrimaryButtonText() {
    if (_remainingSeconds != null && _remainingSeconds! > 0) {
      return "${widget.primaryButtonText} ($_remainingSeconds)";
    }
    return widget.primaryButtonText;
  }

  String _getIconPath() {
    switch (widget.type) {
      case DialogType.warning:
        return IconApp.warning;
      case DialogType.success:
        return IconApp.success;
      case DialogType.info:
        return IconApp.info;
    }
  }

  Color _getPrimaryButtonColor() {
    switch (widget.type) {
      case DialogType.warning:
        return const Color(0xFFFF4444);
      case DialogType.success:
        return const Color(0xFF4CAF50);
      case DialogType.info:
        return const Color(0xFF2196F3);
    }
  }
}

class CupertinoConfirmDialog {
  /// Shows a custom iOS-style confirmation dialog.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Remove",
    String cancelText = "Cancel",
    bool isDestructive = true,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (builderContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(builderContext);
                if (onCancel != null) onCancel();
              },
              child: Text(
                cancelText,
                style: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructive,
              onPressed: () {
                Navigator.pop(builderContext);
                onConfirm();
              },
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
