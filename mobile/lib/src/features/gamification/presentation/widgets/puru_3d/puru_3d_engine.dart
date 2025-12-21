/// 3D Rendering Engine for Puru Mascot
/// 
/// Cung cấp các utilities để render pseudo-3D với:
/// - Lighting calculations (Phong shading)
/// - Depth và shadows
/// - Subsurface scattering simulation
/// - Material properties (glossiness, transparency)

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// 3D Light source
class Light3D {
  final vm.Vector3 position;
  final Color color;
  final double intensity;

  const Light3D({
    required this.position,
    this.color = Colors.white,
    this.intensity = 1.0,
  });
}

/// Material properties for 3D rendering
class Material3D {
  final Color baseColor;
  final double shininess; // 0-100, độ bóng
  final double transparency; // 0-1, độ trong suốt
  final double subsurfaceScattering; // 0-1, ánh sáng xuyên qua
  final double refractiveIndex; // Chỉ số khúc xạ (nước = 1.333)

  const Material3D({
    required this.baseColor,
    this.shininess = 50.0,
    this.transparency = 0.7,
    this.subsurfaceScattering = 0.3,
    this.refractiveIndex = 1.333,
  });
}

/// Phong Lighting Model
/// Tính toán ánh sáng dựa trên normal, view direction, và light position
class PhongLighting {
  /// Tính màu cuối cùng của một điểm dựa trên Phong model
  static Color calculate({
    required vm.Vector3 point,
    required vm.Vector3 normal,
    required vm.Vector3 viewDir,
    required Light3D light,
    required Material3D material,
    Color? ambientColor,
  }) {
    ambientColor ??= material.baseColor.withOpacity(0.2);

    // Ambient component
    final ambient = _colorMultiply(ambientColor, 0.3);

    // Light direction
    final lightDir = (light.position - point).normalized();
    
    // Diffuse component (Lambert)
    final diff = math.max(0.0, normal.dot(lightDir));
    final diffuse = _colorMultiply(material.baseColor, diff * light.intensity);

    // Specular component (Blinn-Phong)
    final halfwayDir = (lightDir + viewDir).normalized();
    final spec = math.pow(
      math.max(0.0, normal.dot(halfwayDir)),
      material.shininess,
    ).toDouble();
    final specular = _colorMultiply(
      light.color,
      spec * light.intensity * 0.5,
    );

    // Combine all components
    return _addColors([ambient, diffuse, specular]);
  }

  static Color _colorMultiply(Color color, double factor) {
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).clamp(0, 255).toInt(),
      (color.green * factor).clamp(0, 255).toInt(),
      (color.blue * factor).clamp(0, 255).toInt(),
    );
  }

  static Color _addColors(List<Color> colors) {
    int r = 0, g = 0, b = 0, a = 255;
    for (final color in colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
      a = color.alpha;
    }
    return Color.fromARGB(
      a,
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255),
    );
  }
}

/// Subsurface Scattering - Ánh sáng xuyên qua bề mặt trong suốt
class SubsurfaceScattering {
  static Color calculate({
    required vm.Vector3 point,
    required vm.Vector3 normal,
    required Light3D light,
    required Material3D material,
    required double thickness, // Độ dày tại điểm này (0-1)
  }) {
    final lightDir = (light.position - point).normalized();
    
    // Ánh sáng xuyên qua từ phía sau
    final backDot = math.max(0.0, -normal.dot(lightDir));
    
    // Attenuation dựa trên độ dày
    final attenuation = math.exp(-thickness * 3.0);
    
    // Màu SSS thường là màu ấm hơn
    final sssColor = Color.lerp(
      material.baseColor,
      material.baseColor.withRed(
        (material.baseColor.red * 1.2).clamp(0, 255).toInt(),
      ),
      0.3,
    )!;

    final intensity = backDot * attenuation * material.subsurfaceScattering;
    
    return PhongLighting._colorMultiply(sssColor, intensity);
  }
}

/// Jelly/Soft-body Physics
/// Simple spring-mass system để tạo hiệu ứng rung
class JellyPhysics {
  final List<JellyVertex> vertices;
  final double stiffness; // Độ cứng (0-1)
  final double damping; // Độ giảm chấn (0-1)

  JellyPhysics({
    required int vertexCount,
    this.stiffness = 0.15,
    this.damping = 0.85,
  }) : vertices = List.generate(
          vertexCount,
          (i) => JellyVertex(index: i),
        );

  /// Áp dụng lực tại một điểm
  void applyForce(int vertexIndex, Offset force) {
    if (vertexIndex >= 0 && vertexIndex < vertices.length) {
      vertices[vertexIndex].velocity += force;
    }
  }

  /// Áp dụng lực tại một vị trí cụ thể (tìm vertex gần nhất)
  void applyForceAtPosition(Offset position, Offset force, List<Offset> vertexPositions) {
    if (vertexPositions.length != vertices.length) return;
    
    // Tìm vertex gần nhất
    int closestIndex = 0;
    double minDist = double.infinity;
    
    for (int i = 0; i < vertexPositions.length; i++) {
      final dist = (vertexPositions[i] - position).distance;
      if (dist < minDist) {
        minDist = dist;
        closestIndex = i;
      }
    }

    applyForce(closestIndex, force);
  }

  /// Update physics simulation
  void update(double dt) {
    for (final vertex in vertices) {
      // Spring force về vị trí gốc
      final springForce = -vertex.offset * stiffness;
      
      // Apply forces
      vertex.velocity += springForce;
      vertex.velocity *= damping; // Damping
      
      // Update position
      vertex.offset += vertex.velocity * dt;
    }
  }

  /// Reset tất cả về trạng thái ban đầu
  void reset() {
    for (final vertex in vertices) {
      vertex.offset = Offset.zero;
      vertex.velocity = Offset.zero;
    }
  }
}

class JellyVertex {
  final int index;
  Offset offset; // Độ lệch so với vị trí ban đầu
  Offset velocity;

  JellyVertex({
    required this.index,
    this.offset = Offset.zero,
    this.velocity = Offset.zero,
  });
}

/// Utility để tạo gradient với lighting
class GradientUtils {
  /// Tạo radial gradient mô phỏng sphere với lighting
  static RadialGradient createSphereGradient({
    required Color baseColor,
    required Alignment lightPosition,
    double shininess = 0.5,
  }) {
    final highlightColor = Color.lerp(baseColor, Colors.white, shininess)!;
    final shadowColor = Color.lerp(baseColor, Colors.black, 0.3)!;

    return RadialGradient(
      center: lightPosition,
      radius: 1.2,
      colors: [
        highlightColor,
        baseColor,
        shadowColor,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
  }

  /// Tạo linear gradient cho subsurface scattering
  static LinearGradient createSSSGradient({
    required Color baseColor,
    required Alignment begin,
    required Alignment end,
  }) {
    final lightColor = Color.lerp(baseColor, Colors.white, 0.4)!;
    
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        lightColor.withOpacity(0.3),
        baseColor.withOpacity(0.7),
        baseColor.withOpacity(0.9),
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

/// Camera/View transformation
class Camera3D {
  vm.Vector3 position;
  vm.Vector3 target;
  vm.Vector3 up;
  double fov; // Field of view in degrees

  Camera3D({
    vm.Vector3? position,
    vm.Vector3? target,
    vm.Vector3? up,
    this.fov = 60.0,
  })  : position = position ?? vm.Vector3(0, 0, 5),
        target = target ?? vm.Vector3.zero(),
        up = up ?? vm.Vector3(0, 1, 0);

  vm.Matrix4 getViewMatrix() {
    return vm.makeViewMatrix(position, target, up);
  }

  vm.Matrix4 getProjectionMatrix(double aspectRatio) {
    return vm.makePerspectiveMatrix(
      fov * math.pi / 180.0,
      aspectRatio,
      0.1,
      100.0,
    );
  }
}

