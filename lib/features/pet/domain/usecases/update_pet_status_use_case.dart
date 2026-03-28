import 'dart:math';
import '../pet_entity.dart';

class UpdatePetStatusUseCase {
  PetEntity call(PetEntity pet, {DateTime? currentTime}) {
    final now = currentTime ?? DateTime.now();
    final difference = now.difference(pet.lastUpdate);

    // If time travel occurred (negative difference), just return the pet as is
    if (difference.isNegative) return pet;

    final double hours = difference.inSeconds / 3600.0;

    // Decay rates (points per hour)
    const double hungerDecayRate = 5.0;
    const double energyDecayRate = 5.0;
    const double happinessDecayRate = 3.0;

    final double hungerLoss = hungerDecayRate * hours;
    final double energyLoss = energyDecayRate * hours;
    final double happinessLoss = happinessDecayRate * hours;

    // Grace period logic: if absent for > 24 hours, stats stop at 5.0
    // We use hours > 24.0 for better precision than integer hours
    final double minStatValue = hours > 24.0 ? 5.0 : 0.0;

    double newHunger = pet.hunger - hungerLoss;
    double newEnergy = pet.energy - energyLoss;
    double newHappiness = pet.happiness - happinessLoss;

    newHunger = max(minStatValue, newHunger);
    newEnergy = max(minStatValue, newEnergy);
    newHappiness = max(minStatValue, newHappiness);

    return pet.copyWith(
      hunger: newHunger,
      energy: newEnergy,
      happiness: newHappiness,
      lastUpdate: now,
    );
  }
}
