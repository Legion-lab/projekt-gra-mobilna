import 'package:app/features/pet/domain/pet_entity.dart';
import 'package:app/features/pet/domain/usecases/apply_user_activity_use_case.dart';
import 'package:app/features/pet/domain/usecases/update_pet_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final updateStatusUseCase = UpdatePetStatusUseCase();
  final applyActivityUseCase = ApplyUserActivityUseCase();

  test('Combined Scenario: 48h absence then 20000 steps', () {
    final now = DateTime.now();
    final lastUpdate = now.subtract(const Duration(hours: 48));

    // Initial State: 100% stats (100.0), morphology 0.1
    // The prompt says "statystyki = 1.0 (100%)". Based on previous context, core stats are 0-100.
    // So 100% = 100.0.
    final initialPet = PetEntity(
      hunger: 100.0,
      happiness: 100.0,
      energy: 100.0,
      lastUpdate: lastUpdate,
      fitnessLevel: 0.1,
      intelligenceLevel: 0.1,
      energyReserves: 0.1,
    );

    print('Initial Pet: Hunger=${initialPet.hunger}, Happiness=${initialPet.happiness}, Energy=${initialPet.energy}, Fitness=${initialPet.fitnessLevel}');

    // Step 1: Update Status (48 hours decay)
    // 48 hours > 24 hours -> Grace period applies.
    // Decay: Hunger/Energy -5/h * 48 = -240. Should be clamped to 5.0.
    // Decay: Happiness -3/h * 48 = -144. Should be clamped to 5.0.
    final decayedPet = updateStatusUseCase(initialPet, currentTime: now);

    print('After 48h Decay: Hunger=${decayedPet.hunger}, Happiness=${decayedPet.happiness}, Energy=${decayedPet.energy}');

    expect(decayedPet.hunger, 5.0, reason: 'Hunger should be clamped to grace period floor (5.0)');
    expect(decayedPet.energy, 5.0, reason: 'Energy should be clamped to grace period floor (5.0)');
    expect(decayedPet.happiness, 5.0, reason: 'Happiness should be clamped to grace period floor (5.0)');
    expect(decayedPet.lastUpdate, now);

    // Step 2: Apply Activity (20,000 steps)
    // Fitness increase: (20000 - 2000) / 1000 * 0.05 = 18 * 0.05 = 0.9.
    // Smoothing cap: 0.1.
    // New Fitness: 0.1 + 0.1 = 0.2.
    final activePet = applyActivityUseCase(decayedPet, stepsCount: 20000, logicGamesScore: 0);

    print('After 20000 Steps: Fitness=${activePet.fitnessLevel}');

    expect(activePet.fitnessLevel, closeTo(0.2, 0.001), reason: 'Fitness should increase by max 0.1 due to smoothing');
    expect(activePet.energyReserves, 0.1, reason: 'Energy reserves should not change (steps > 1000)');
  });
}
