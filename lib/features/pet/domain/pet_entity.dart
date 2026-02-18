class PetEntity {
  final double hunger;
  final double happiness;
  final double energy;
  final DateTime lastUpdate;

  PetEntity({
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.lastUpdate,
  });

  bool get isAlive => hunger > 0 && happiness > 0 && energy > 0;
}
