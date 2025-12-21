/// Màn hình so sánh 3 options Puru 3D
/// 
/// Hiển thị cả 3 phiên bản Puru để user có thể lựa chọn design ưng ý nhất.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'puru_3d_engine.dart';
import 'puru_option0_classic.dart';
import 'puru_option1_celestial_v2.dart';
import 'puru_option2_axo_v2.dart';
import 'puru_option3_chibi_bot_v2.dart';

class Puru3DComparisonShowcase extends ConsumerStatefulWidget {
  const Puru3DComparisonShowcase({super.key});

  @override
  ConsumerState<Puru3DComparisonShowcase> createState() =>
      _Puru3DComparisonShowcaseState();
}

class _Puru3DComparisonShowcaseState
    extends ConsumerState<Puru3DComparisonShowcase>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _rotationController;
  late AnimationController _hueController;

  late JellyPhysics _physics0;
  late JellyPhysics _physics1;
  late JellyPhysics _physics2;
  late JellyPhysics _physics3;

  double _hydrationPercent = 0.75;
  int _selectedOption = 0; // 0 = None, 1-3 = Option number

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _hueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _physics0 = JellyPhysics(vertexCount: 20);
    _physics1 = JellyPhysics(vertexCount: 20);
    _physics2 = JellyPhysics(vertexCount: 20);
    _physics3 = JellyPhysics(vertexCount: 20);

    // Physics update loop
    _startPhysicsLoop();
  }

  void _startPhysicsLoop() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        setState(() {
          _physics0.update(0.016);
          _physics1.update(0.016);
          _physics2.update(0.016);
          _physics3.update(0.016);
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _rotationController.dispose();
    _hueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001220),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chọn Design Cho Puru',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Hydration slider control
          _buildHydrationControl(),

          const SizedBox(height: 20),

          // Main comparison view
          Expanded(
            child: _selectedOption == 0
                ? _buildThreeColumnView()
                : _buildSingleOptionView(_selectedOption),
          ),

          // Bottom action buttons
          _buildActionButtons(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHydrationControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hydration Level:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(_hydrationPercent * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF2AF598),
              inactiveTrackColor: Colors.white24,
              thumbColor: const Color(0xFF009EFD),
              overlayColor: const Color(0xFF2AF598).withOpacity(0.3),
              trackHeight: 6,
            ),
            child: Slider(
              value: _hydrationPercent,
              onChanged: (value) {
                setState(() {
                  _hydrationPercent = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeColumnView() {
    return Row(
      children: [
        Expanded(
          child: _buildOptionCard(
            optionNumber: 0,
            title: 'Classic Puru',
            subtitle: 'Original & Beloved',
            child: _buildOption0Widget(size: 220),
          ),
        ),
        Expanded(
          child: _buildOptionCard(
            optionNumber: 1,
            title: 'Celestial Drop',
            subtitle: 'Mềm mại & Lấp lánh',
            child: _buildOption1Widget(size: 220),
          ),
        ),
        Expanded(
          child: _buildOptionCard(
            optionNumber: 2,
            title: 'Aqua-Axo',
            subtitle: 'Đáng yêu & Vui nhộn',
            child: _buildOption2Widget(size: 220),
          ),
        ),
        Expanded(
          child: _buildOptionCard(
            optionNumber: 3,
            title: 'Liquid Chibi-Bot',
            subtitle: 'Tech & Holographic',
            child: _buildOption3Widget(size: 220),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleOptionView(int option) {
    Widget mascotWidget;
    String title;
    String description;

    switch (option) {
      case 0:
        mascotWidget = _buildOption0Widget(size: 400);
        title = 'Option 0: Classic Puru (Original)';
        description =
            '💧 Mascot gốc của SmartHydro - đã được yêu thích\n'
            '🎨 Thiết kế đơn giản, trong trẻo, dễ thương\n'
            '✨ Bọt khí bay lơ lửng bên trong\n'
            '😊 Biểu cảm phong phú và tự nhiên\n'
            '🌊 Soft-body physics mượt mà\n'
            '🎬 Phong cách: Timeless, Friendly, Approachable';
        break;
      case 1:
        mascotWidget = _buildOption1Widget(size: 400);
        title = 'Option 1: Celestial Drop V2';
        description =
            '✨ Giọt nước với ánh sáng mềm mại\n'
            '💫 Hạt lấp lánh tinh tế (không quá nhiều)\n'
            '👁️ Đôi mắt đơn giản, dễ thương\n'
            '🌟 Glow effect nhẹ nhàng\n'
            '🎨 Phong cách: Elegant, Soft, Magical\n'
            '🎬 Redesigned: Đơn giản hóa, tập trung vào ánh sáng';
        break;
      case 2:
        mascotWidget = _buildOption2Widget(size: 400);
        title = 'Option 2: Aqua-Axo V2';
        description =
            '🦎 Lấy cảm hứng từ Axolotl\n'
            '🌊 2 vây tai nhỏ đơn giản (không phức tạp)\n'
            '👀 Mắt cách xa tạo vẻ ngây thơ\n'
            '🐾 Đuôi ngắn gọn, vẫy nhẹ\n'
            '💗 Má hồng dễ thương\n'
            '🎨 Phong cách: Cute, Playful, Pet-like\n'
            '🎬 Redesigned: Đơn giản hóa vây tai và đuôi';
        break;
      case 3:
        mascotWidget = _buildOption3Widget(size: 400);
        title = 'Option 3: Liquid Chibi-Bot V2';
        description =
            '💎 Giọt nước với viền holographic\n'
            '⚡ Lõi năng lượng phát sáng đơn giản\n'
            '🌈 Hiệu ứng cầu vồng tinh tế\n'
            '👁️ Mắt và miệng LED đơn giản\n'
            '✨ Glass-like body trong suốt\n'
            '🎨 Phong cách: Tech, Modern, Premium\n'
            '🎬 Redesigned: Bỏ circuit, tập trung vào holographic';
        break;
      default:
        mascotWidget = Container();
        title = '';
        description = '';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Large mascot display
          Container(
            width: 450,
            height: 450,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF009EFD).withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(child: mascotWidget),
          ),

          const SizedBox(height: 30),

          // Title and description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required int optionNumber,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final isSelected = _selectedOption == optionNumber;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = _selectedOption == optionNumber ? 0 : optionNumber;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF009EFD).withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2AF598)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2AF598).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascot
            SizedBox(
              height: 250,
              child: Center(child: child),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2AF598) : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Selection indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2AF598),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '✓ Đã chọn',
                  style: TextStyle(
                    color: Color(0xFF051E3E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption0Widget({required double size}) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: PuruClassicPainter(
            animationValue: _breathingController.value,
            physics: _physics0,
            hydrationPercent: _hydrationPercent,
          ),
        );
      },
    );
  }

  Widget _buildOption1Widget({required double size}) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: PuruCelestialV2Painter(
            animationValue: _breathingController.value,
            physics: _physics1,
            hydrationPercent: _hydrationPercent,
          ),
        );
      },
    );
  }

  Widget _buildOption2Widget({required double size}) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: PuruAxoV2Painter(
            animationValue: _breathingController.value,
            physics: _physics2,
            hydrationPercent: _hydrationPercent,
          ),
        );
      },
    );
  }

  Widget _buildOption3Widget({required double size}) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingController,
        _hueController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: PuruChibiBotV2Painter(
            animationValue: _breathingController.value,
            hueShift: _hueController.value * 360,
            physics: _physics3,
            hydrationPercent: _hydrationPercent,
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Back to comparison button
          if (_selectedOption != 0)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedOption = 0;
                  });
                },
                icon: const Icon(Icons.grid_view),
                label: const Text('Xem tất cả'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),

          if (_selectedOption != 0) const SizedBox(width: 12),

          // Confirm selection button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _selectedOption == 0
                  ? null
                  : () {
                      _showConfirmDialog();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2AF598),
                foregroundColor: const Color(0xFF051E3E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                disabledBackgroundColor: Colors.white.withOpacity(0.1),
              ),
              child: Text(
                _selectedOption == 0
                    ? 'Chọn một option để tiếp tục'
                    : 'Xác nhận Option $_selectedOption',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF001220),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color(0xFF2AF598),
            width: 2,
          ),
        ),
        title: const Text(
          '🎉 Lựa chọn tuyệt vời!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn đã chọn Option $_selectedOption!\n\n'
          'Design này sẽ được sử dụng để phát triển mascot Puru cho SmartHydro.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Quay lại',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, _selectedOption);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2AF598),
              foregroundColor: const Color(0xFF051E3E),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

