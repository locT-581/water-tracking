import 'package:flutter/material.dart';

import 'puru.dart';

/// Showcase widget to preview all Puru states
/// 
/// Use this during development to see all Puru variations.
/// Navigate to this screen to test different states and expressions.
class PuruShowcase extends StatefulWidget {
  const PuruShowcase({super.key});
  
  @override
  State<PuruShowcase> createState() => _PuruShowcaseState();
}

class _PuruShowcaseState extends State<PuruShowcase> {
  double _hydrationPercent = 0.5;
  PuruExpression _expression = PuruExpression.happy;
  PuruAccessory _accessory = PuruAccessory.none;
  bool _isSleeping = false;
  bool _isHotWeather = false;
  bool _justWorkedOut = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        title: const Text('Puru Showcase'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Puru Display
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: PuruWidget(
                  size: 200,
                  hydrationPercent: _hydrationPercent,
                  isSleeping: _isSleeping,
                  isHotWeather: _isHotWeather,
                  justWorkedOut: _justWorkedOut,
                  expression: _expression,
                  accessory: _accessory,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Puru tapped!')),
                    );
                  },
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Puru hugged!')),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Hydration Slider
            _buildSection(
              'Hydration Level',
              Column(
                children: [
                  Slider(
                    value: _hydrationPercent,
                    min: 0,
                    max: 1.5,
                    divisions: 30,
                    label: '${(_hydrationPercent * 100).toInt()}%',
                    activeColor: const Color(0xFF009EFD),
                    onChanged: (value) {
                      setState(() => _hydrationPercent = value);
                    },
                  ),
                  Text(
                    '${(_hydrationPercent * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF051E3E),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Context Toggles
            _buildSection(
              'Context',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('😴 Sleeping'),
                    selected: _isSleeping,
                    onSelected: (v) => setState(() => _isSleeping = v),
                  ),
                  FilterChip(
                    label: const Text('☀️ Hot Weather'),
                    selected: _isHotWeather,
                    onSelected: (v) => setState(() => _isHotWeather = v),
                  ),
                  FilterChip(
                    label: const Text('💪 Just Worked Out'),
                    selected: _justWorkedOut,
                    onSelected: (v) => setState(() => _justWorkedOut = v),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Expression Selector
            _buildSection(
              'Expression Override',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PuruExpression.values.map((expr) {
                  return ChoiceChip(
                    label: Text(_getExpressionLabel(expr)),
                    selected: _expression == expr,
                    onSelected: (v) {
                      if (v) setState(() => _expression = expr);
                    },
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Accessory Selector
            _buildSection(
              'Accessory',
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PuruAccessory.values.map((acc) {
                  return ChoiceChip(
                    label: Text(_getAccessoryLabel(acc)),
                    selected: _accessory == acc,
                    onSelected: (v) {
                      if (v) setState(() => _accessory = acc);
                    },
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // State Gallery
            _buildSection(
              'All Hydration States',
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatePreview('Hydrated\n(100%+)', 1.0),
                    _buildStatePreview('Good\n(75-99%)', 0.85),
                    _buildStatePreview('Okay\n(50-74%)', 0.6),
                    _buildStatePreview('Thirsty\n(25-49%)', 0.35),
                    _buildStatePreview('Dehydrated\n(0-24%)', 0.15),
                    _buildStatePreview('Over\n(120%+)', 1.3),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Mini & Loading Variants
            _buildSection(
              'Widget Variants',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      PuruMini(
                        size: 60,
                        hydrationPercent: _hydrationPercent,
                      ),
                      const SizedBox(height: 8),
                      const Text('PuruMini'),
                    ],
                  ),
                  const Column(
                    children: [
                      PuruLoading(
                        size: 80,
                        message: 'Loading...',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF051E3E),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
  
  Widget _buildStatePreview(String label, double hydration) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          PuruMini(
            size: 80,
            hydrationPercent: hydration,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF051E3E),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getExpressionLabel(PuruExpression expr) {
    switch (expr) {
      case PuruExpression.happy: return '😊 Happy';
      case PuruExpression.joyful: return '😄 Joyful';
      case PuruExpression.excited: return '🤩 Excited';
      case PuruExpression.confused: return '🤔 Confused';
      case PuruExpression.worried: return '😟 Worried';
      case PuruExpression.sad: return '😢 Sad';
      case PuruExpression.sleepy: return '😴 Sleepy';
      case PuruExpression.dizzy: return '😵 Dizzy';
      case PuruExpression.determined: return '😤 Determined';
      case PuruExpression.surprised: return '😲 Surprised';
      case PuruExpression.winking: return '😉 Winking';
    }
  }
  
  String _getAccessoryLabel(PuruAccessory acc) {
    switch (acc) {
      case PuruAccessory.none: return '❌ None';
      case PuruAccessory.sunglasses: return '🕶️ Sunglasses';
      case PuruAccessory.dumbbells: return '🏋️ Dumbbells';
      case PuruAccessory.coffee: return '☕ Coffee';
      case PuruAccessory.sosSign: return '🆘 SOS';
      case PuruAccessory.crown: return '👑 Crown';
      case PuruAccessory.medal: return '🏅 Medal';
      case PuruAccessory.sleepCap: return '🧢 Sleep Cap';
      case PuruAccessory.umbrella: return '☂️ Umbrella';
      case PuruAccessory.scarf: return '🧣 Scarf';
    }
  }
}

/// Quick preview screen that cycles through all states
class PuruAnimationDemo extends StatefulWidget {
  const PuruAnimationDemo({super.key});
  
  @override
  State<PuruAnimationDemo> createState() => _PuruAnimationDemoState();
}

class _PuruAnimationDemoState extends State<PuruAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001220),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Cycle hydration from 0 to 150%
            final hydration = (_controller.value * 1.5).clamp(0.0, 1.5);
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PuruWidget(
                  size: 250,
                  hydrationPercent: hydration,
                  showGlowEffect: true,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(hydration * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

