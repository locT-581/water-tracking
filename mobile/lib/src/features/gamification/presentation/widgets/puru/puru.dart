/// Puru Mascot Widget Library
/// 
/// The complete Puru mascot system for SmartHydro app.
/// Includes states, animations, expressions, accessories, skins, and effects.
/// 
/// ## Basic usage:
/// ```dart
/// PuruWidget(
///   size: 200,
///   hydrationPercent: 0.75,
///   onTap: () => print('Puru tapped!'),
/// )
/// ```
/// 
/// ## For smaller spaces:
/// ```dart
/// PuruMini(
///   size: 60,
///   hydrationPercent: 0.5,
/// )
/// ```
/// 
/// ## For loading states:
/// ```dart
/// PuruLoading(
///   message: 'Đang tải...',
/// )
/// ```
/// 
/// ## Available States:
/// - `hydrated` (100%+): Glowing, floating, very happy
/// - `good` (75-99%): Normal, content
/// - `okay` (50-74%): Slightly concerned
/// - `thirsty` (25-49%): Deflated, worried
/// - `dehydrated` (0-24%): Melting, sad, SOS
/// - `overHydrated` (120%+): Bloated, hiccup bubbles
/// - `sleeping`: During sleep hours
/// 
/// ## Expressions:
/// happy, joyful, excited, confused, worried, sad, sleepy, 
/// dizzy, determined, surprised, winking
/// 
/// ## Accessories:
/// sunglasses, dumbbells, coffee, sosSign, crown, medal,
/// sleepCap, umbrella, scarf
/// 
/// ## Skins (unlockable):
/// classic, summer, winter, forest, galaxy, sakura, 
/// golden, rainbow, midnight, crystal
/// 
/// ## Evolution Stages:
/// baby (0d), toddler (7d), youth (30d), adult (90d),
/// elder (180d), legendary (365d)
library puru;

// Core
export 'puru_state.dart';
export 'puru_colors.dart';

// Painters
export 'puru_body_painter.dart';
export 'puru_face_painter.dart';
export 'puru_accessory_painter.dart';

// Animation & Logic
export 'puru_animation_controller.dart';
export 'puru_effects.dart';
export 'puru_reactions.dart';

// Widgets
export 'puru_widget.dart';
export 'puru_showcase.dart';

// Customization
export 'puru_skins.dart';
export 'puru_evolution.dart';

