import 'package:app/features/pet/domain/pet_entity.dart';
import 'package:app/features/pet/domain/usecases/update_pet_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UpdatePetStatusUseCase useCase;

  setUp(() {
    useCase = UpdatePetStatusUseCase();
  });

  final baseTime = DateTime(2023, 1, 1, 10, 0, 0);
  final basePet = PetEntity(
    hunger: 100.0,
    happiness: 100.0,
    energy: 100.0,
    lastUpdate: baseTime,
    fitnessLevel: 0.5,
    intelligenceLevel: 0.5,
    energyReserves: 0.5,
  );

  test('should decay stats correctly after 1 hour', () {
    final currentTime = baseTime.add(const Duration(hours: 1));
    final result = useCase(basePet, currentTime: currentTime);

    expect(result.hunger, closeTo(95.0, 0.001)); // -5
    expect(result.energy, closeTo(95.0, 0.001)); // -5
    expect(result.happiness, closeTo(97.0, 0.001)); // -3
    expect(result.lastUpdate, currentTime);
  });

  test('should stop at 0.0 if time < 24h and decay is complete', () {
    // 21 hours * 5 = 105 decay. Should hit 0.0.
    final currentTime = baseTime.add(const Duration(hours: 21));
    final result = useCase(basePet, currentTime: currentTime);

    expect(result.hunger, 0.0);
    expect(result.energy, 0.0);
    expect(result.happiness, closeTo(100 - (3 * 21), 0.001)); // 37
  });

  test('should trigger grace period if time > 24h', () {
    // 25 hours. Decay would be 125. Result -25. Grace period floor 5.0.
    final currentTime = baseTime.add(const Duration(hours: 25));
    final result = useCase(basePet, currentTime: currentTime);

    expect(result.hunger, 5.0);
    expect(result.energy, 5.0);
    // Happiness: 100 - 3*25 = 25. Grace period floor 5.0. Result 25.
    expect(result.happiness, closeTo(25.0, 0.001));
  });

  test('should trigger grace period floor for happiness too if needed', () {
    // 40 hours. Happiness loss 120. Result -20. Floor 5.0.
    final currentTime = baseTime.add(const Duration(hours: 40));
    final result = useCase(basePet, currentTime: currentTime);

    expect(result.happiness, 5.0);
  });

  test('should handle negative time gracefully', () {
    final currentTime = baseTime.subtract(const Duration(hours: 1));
    final result = useCase(basePet, currentTime: currentTime);

    expect(result, basePet);
  });
}
