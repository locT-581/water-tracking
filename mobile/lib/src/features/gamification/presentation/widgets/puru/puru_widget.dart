import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'puru_state.dart';
import 'puru_colors.dart';
import 'puru_body_painter.dart';
import 'puru_face_painter.dart';
import 'puru_accessory_painter.dart';
import 'puru_animation_controller.dart';
import 'puru_effects.dart';
import 'puru_reactions.dart';

/// Main Puru mascot widget
/// 
/// This widget displays the Puru mascot with all animations,
/// expressions, accessories, and interactive behaviors.
class PuruWidget extends StatefulWidget {
  /// Size of the Puru widget (width and height)
  final double size;
  
  /// Initial hydration percentage (0.0 to 1.0+)
  final double hydrationPercent;
  
  /// Whether it's currently sleeping hours
  final bool isSleeping;
  
  /// Whether the weather is hot (>30°C)
  final bool isHotWeather;
  
  /// Whether user just worked out
  final bool justWorkedOut;
  
  /// Custom accessory to display
  final PuruAccessory? accessory;
  
  /// Custom expression to display
  final PuruExpression? expression;
  
  /// Callback when Puru is tapped
  final VoidCallback? onTap;
  
  /// Callback when Puru is long pressed
  final VoidCallback? onLongPress;
  
  /// Whether to show message bubble
  final bool showMessage;
  
  /// Custom message to display
  final String? customMessage;
  
  /// Whether to enable interactive eye tracking
  final bool enableEyeTracking;
  
  /// Whether to show glow effect when hydrated
  final bool showGlowEffect;
  
  const PuruWidget({
    super.key,
    this.size = 200,
    this.hydrationPercent = 0.5,
    this.isSleeping = false,
    this.isHotWeather = false,
    this.justWorkedOut = false,
    this.accessory,
    this.expression,
    this.onTap,
    this.onLongPress,
    this.showMessage = true,
    this.customMessage,
    this.enableEyeTracking = true,
    this.showGlowEffect = true,
  });
  
  @override
  State<PuruWidget> createState() => _PuruWidgetState();
}

class _PuruWidgetState extends State<PuruWidget> with TickerProviderStateMixin {
  late PuruAnimationController _animController;
  String _currentMessage = '';
  Timer? _messageTimer;
  bool _isShowingReaction = false;
  
  @override
  void initState() {
    super.initState();
    _animController = PuruAnimationController(
      vsync: this,
      initialState: _createState(),
    );
    _animController.addListener(_onAnimationUpdate);
    _updateMessage();
  }
  
  @override
  void didUpdateWidget(PuruWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.hydrationPercent != oldWidget.hydrationPercent ||
        widget.isSleeping != oldWidget.isSleeping ||
        widget.isHotWeather != oldWidget.isHotWeather ||
        widget.justWorkedOut != oldWidget.justWorkedOut ||
        widget.accessory != oldWidget.accessory ||
        widget.expression != oldWidget.expression) {
      _animController.updateState(_createState());
      
      // Check if hydration increased (user logged water)
      if (widget.hydrationPercent > oldWidget.hydrationPercent) {
        _onWaterLogged(
          ((widget.hydrationPercent - oldWidget.hydrationPercent) * 2000).round(),
        );
      }
    }
  }
  
  PuruCompleteState _createState() {
    var state = PuruCompleteState.fromHydration(
      widget.hydrationPercent,
      isSleeping: widget.isSleeping,
      isHotWeather: widget.isHotWeather,
      justWorkedOut: widget.justWorkedOut,
    );
    
    // Apply custom overrides
    if (widget.accessory != null) {
      state = state.copyWith(accessory: widget.accessory);
    }
    if (widget.expression != null) {
      state = state.copyWith(expression: widget.expression);
    }
    if (widget.customMessage != null) {
      state = state.copyWith(customMessage: widget.customMessage);
    }
    
    return state;
  }
  
  void _onAnimationUpdate() {
    if (mounted) setState(() {});
  }
  
  void _updateMessage() {
    if (!_isShowingReaction) {
      _currentMessage = widget.customMessage ?? 
          _animController.state.messageVi;
    }
  }
  
  void _onWaterLogged(int volumeMl) {
    // Play drink animation
    _animController.playDrinkAnimation();
    
    // Show reaction message
    _showReaction(PuruReactions.getLogReaction(
      volumeMl,
      widget.hydrationPercent,
    ));
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
    
    // Check if goal reached
    if (widget.hydrationPercent >= 1.0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _animController.playCelebration();
      });
    }
  }
  
  void _showReaction(String message) {
    setState(() {
      _currentMessage = message;
      _isShowingReaction = true;
    });
    
    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isShowingReaction = false;
          _updateMessage();
        });
      }
    });
  }
  
  void _handleTap() {
    // Squish animation
    _animController.squish();
    
    // Haptic feedback
    HapticFeedback.lightImpact();
    
    // Show tap reaction
    _showReaction(PuruReactions.getTapReaction());
    
    // Call callback
    widget.onTap?.call();
  }
  
  void _handleLongPress() {
    // Bounce animation
    _animController.bounce();
    
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    // Show reaction
    _showReaction(PuruReactions.getLongPressReaction());
    
    // Call callback
    widget.onLongPress?.call();
  }
  
  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.enableEyeTracking) return;
    
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    
    // Normalize to -1 to 1 range
    final normalizedX = (local.dx / box.size.width - 0.5) * 2;
    final normalizedY = (local.dy / box.size.height - 0.5) * 2;
    
    _animController.updateEyePosition(normalizedX, normalizedY);
  }
  
  void _handlePanEnd(DragEndDetails details) {
    _animController.resetEyePosition();
  }
  
  @override
  void dispose() {
    _messageTimer?.cancel();
    _animController.removeListener(_onAnimationUpdate);
    _animController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final state = _animController.state;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Message bubble
        if (widget.showMessage)
          _buildMessageBubble(),
        
        const SizedBox(height: 8),
        
        // Puru character
        GestureDetector(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect (behind body)
                if (widget.showGlowEffect && 
                    state.hydrationState == PuruHydrationState.hydrated)
                  Positioned.fill(
                    child: HydrationGlowEffect(
                      isActive: true,
                      color: state.glowColor,
                      size: widget.size,
                    ),
                  ),
                
                // Body
                Transform.translate(
                  offset: Offset(0, _animController.floatOffset),
                  child: Transform.scale(
                    scale: 1 + _animController.bounceProgress * 0.1,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: PuruBodyPainter(
                        state: state,
                        breathProgress: _animController.breathProgress,
                        squishProgress: _animController.squishProgress,
                        bounceProgress: _animController.bounceProgress,
                        floatOffset: 0, // Already handled by transform
                        wobblePhase: _animController.wobblePhase,
                        bubbles: _animController.bubbles,
                      ),
                    ),
                  ),
                ),
                
                // Face
                Transform.translate(
                  offset: Offset(0, _animController.floatOffset),
                  child: Transform.scale(
                    scale: 1 + _animController.bounceProgress * 0.1,
                    child: CustomPaint(
                      size: Size(widget.size * 0.6, widget.size * 0.6),
                      painter: PuruFacePainter(
                        expression: state.expression,
                        blinkProgress: _animController.blinkProgress,
                        eyeOffsetX: _animController.eyeOffsetX,
                        eyeOffsetY: _animController.eyeOffsetY,
                      ),
                    ),
                  ),
                ),
                
                // Accessory
                if (state.accessory != PuruAccessory.none)
                  Transform.translate(
                    offset: Offset(0, _animController.floatOffset),
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: PuruAccessoryPainter(
                        accessory: state.accessory,
                        animationProgress: _animController.accessoryProgress,
                      ),
                    ),
                  ),
                
                // Effects
                // Hiccup bubbles for over-hydrated
                if (state.hydrationState == PuruHydrationState.overHydrated)
                  Positioned(
                    top: 0,
                    child: HiccupBubblesEffect(
                      isActive: true,
                      size: widget.size,
                    ),
                  ),
                
                // Sleep Zzz
                if (state.hydrationState == PuruHydrationState.sleeping)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SleepZzzEffect(
                      isActive: true,
                      size: widget.size * 0.5,
                    ),
                  ),
                
                // Water drips for dehydrated
                if (state.hydrationState == PuruHydrationState.dehydrated)
                  Positioned(
                    bottom: -widget.size * 0.3,
                    child: WaterDripEffect(
                      isActive: true,
                      size: widget.size,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMessageBubble() {
    return AnimatedOpacity(
      opacity: _currentMessage.isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.size * 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: PuruColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          _currentMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF051E3E),
          ),
        ),
      ),
    );
  }
}

/// Compact Puru widget for use in smaller spaces (widgets, list items)
class PuruMini extends StatelessWidget {
  final double size;
  final double hydrationPercent;
  final VoidCallback? onTap;
  
  const PuruMini({
    super.key,
    this.size = 60,
    this.hydrationPercent = 0.5,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return PuruWidget(
      size: size,
      hydrationPercent: hydrationPercent,
      onTap: onTap,
      showMessage: false,
      enableEyeTracking: false,
      showGlowEffect: false,
    );
  }
}

/// Animated Puru for loading states
class PuruLoading extends StatefulWidget {
  final double size;
  final String? message;
  
  const PuruLoading({
    super.key,
    this.size = 100,
    this.message,
  });
  
  @override
  State<PuruLoading> createState() => _PuruLoadingState();
}

class _PuruLoadingState extends State<PuruLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.9 + 0.1 * (1 + 
                  ((_controller.value * 2 * 3.14159).abs() < 3.14159 
                      ? (_controller.value * 2 * 3.14159).abs() 
                      : (2 * 3.14159 - (_controller.value * 2 * 3.14159).abs())).clamp(0, 3.14159) / 3.14159),
              child: PuruWidget(
                size: widget.size,
                hydrationPercent: 0.5 + _controller.value * 0.3,
                showMessage: false,
                enableEyeTracking: false,
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF051E3E),
            ),
          ),
        ],
      ],
    );
  }
}

