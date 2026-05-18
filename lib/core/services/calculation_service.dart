import '../models/renovation_project.dart';
import '../../data/renovation_ratios.dart';

class CalculationResult {
  CalculationResult({
    required this.surface,
    required this.materialQuantity,
    required this.glueQuantity,
    required this.jointQuantity,
    required this.paintQuantity,
    required this.skirtingQuantity,
    required this.estimatedBudget,
  });

  final double surface;
  final double materialQuantity;
  final double glueQuantity;
  final double jointQuantity;
  final double paintQuantity;
  final double skirtingQuantity;
  final double estimatedBudget;
}

class CalculationService {
  static CalculationResult calculate(RenovationProject project) {
    final surface = project.floorArea;

    final adjustedSurface = RenovationRatios.applyWaste(
      surface,
      project.wastePercent,
    );

    final glue = adjustedSurface * RenovationRatios.tileGlueKgPerM2;
    final joints = adjustedSurface * RenovationRatios.tileJointKgPerM2;
    final paint = project.wallArea * RenovationRatios.paintLiterPerM2;
    final skirting = project.perimeter * 1.1;

    double estimatedBudget = adjustedSurface * 35;

    if (project.qualityLevel == QualityLevel.standard) {
      estimatedBudget *= 1.25;
    }

    if (project.qualityLevel == QualityLevel.premium) {
      estimatedBudget *= 1.6;
    }

    if (project.installedByArtisan) {
      estimatedBudget += adjustedSurface * 45;
    }

    return CalculationResult(
      surface: surface,
      materialQuantity: adjustedSurface,
      glueQuantity: glue,
      jointQuantity: joints,
      paintQuantity: paint,
      skirtingQuantity: skirting,
      estimatedBudget: estimatedBudget,
    );
  }
}
