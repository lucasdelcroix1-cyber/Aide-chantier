enum RoomType { salon, cuisine, salleDeBain, chambre, couloir, autre }

enum RenovationType { carrelage, parquet, peinture, plinthes }

enum QualityLevel { economique, standard, premium }

class RenovationProject {
  const RenovationProject({
    required this.name,
    required this.roomType,
    required this.renovationType,
    required this.length,
    required this.width,
    required this.height,
    required this.wastePercent,
    required this.qualityLevel,
    required this.includeTools,
    required this.includeConsumables,
    required this.installedByArtisan,
  });

  final String name;
  final RoomType roomType;
  final RenovationType renovationType;
  final double length;
  final double width;
  final double height;
  final double wastePercent;
  final QualityLevel qualityLevel;
  final bool includeTools;
  final bool includeConsumables;
  final bool installedByArtisan;

  double get floorArea => length * width;
  double get perimeter => (length + width) * 2;
  double get wallArea => perimeter * height;
}
