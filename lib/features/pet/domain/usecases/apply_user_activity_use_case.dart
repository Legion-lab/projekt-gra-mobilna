import 'dart:math';
import '../pet_entity.dart';

class ApplyUserActivityUseCase {
  PetEntity call(PetEntity pet, {required int stepsCount, required int logicGamesScore}) {
    // FITNESS Logic
    double newFitness = pet.fitnessLevel;
    if (stepsCount > 2000) {
      // Calculate increase for steps above threshold
      double fitnessIncrease = ((stepsCount - 2000) / 1000.0) * 0.05;

      // Smoothing: change cannot exceed 0.1 per update
      fitnessIncrease = min(fitnessIncrease, 0.1);

      newFitness += fitnessIncrease;
    }

    // Ensure fitness stays within 0.0 - 1.0 range
    newFitness = newFitness.clamp(0.0, 1.0);

    // INTELLIGENCE Logic
    // Each point in logicGamesScore increases intelligence by 0.02
    double intelligenceIncrease = logicGamesScore * 0.02;
    double newIntelligence = (pet.intelligenceLevel + intelligenceIncrease).clamp(0.0, 1.0);

    // LAZINESS Logic (Energy Reserves)
    // Lack of activity (steps < 1000) increases laziness weight
    double newEnergyReserves = pet.energyReserves;
    if (stepsCount < 1000) {
      newEnergyReserves += 0.05;
    }

    // Ensure energy reserves stay within 0.0 - 1.0 range
    newEnergyReserves = newEnergyReserves.clamp(0.0, 1.0);

    return pet.copyWith(
      fitnessLevel: newFitness,
      intelligenceLevel: newIntelligence,
      energyReserves: newEnergyReserves,
    );
  }
}
