class PetEntity {
  final double hunger;
  final double happiness;
  final double energy;
  final DateTime lastUpdate;

  final double fitnessLevel;
  final double intelligenceLevel;
  final double energyReserves;

  PetEntity({
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.lastUpdate,
    required this.fitnessLevel,
    required this.intelligenceLevel,
    required this.energyReserves,
  }) {
    if (fitnessLevel < 0.0 || fitnessLevel > 1.0) {
      throw ArgumentError('Fitness Level must be between 0.0 and 1.0');
    }
    if (intelligenceLevel < 0.0 || intelligenceLevel > 1.0) {
      throw ArgumentError('Intelligence Level must be between 0.0 and 1.0');
    }
    if (energyReserves < 0.0 || energyReserves > 1.0) {
      throw ArgumentError('Energy Reserves must be between 0.0 and 1.0');
    }
  }

  bool get isAlive => hunger > 0 && happiness > 0 && energy > 0;

  PetEntity copyWith({
    double? hunger,
    double? happiness,
    double? energy,
    DateTime? lastUpdate,
    double? fitnessLevel,
    double? intelligenceLevel,
    double? energyReserves,
  }) {
    return PetEntity(
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      intelligenceLevel: intelligenceLevel ?? this.intelligenceLevel,
      energyReserves: energyReserves ?? this.energyReserves,
    );
  }
}
