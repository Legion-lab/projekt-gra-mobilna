import 'package:app/features/pet/domain/pet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PetEntity', () {
    final now = DateTime.now();

    test('should be created with valid values', () {
      final pet = PetEntity(
        hunger: 0.5,
        happiness: 0.5,
        energy: 0.5,
        lastUpdate: now,
        fitnessLevel: 0.5,
        intelligenceLevel: 0.5,
        energyReserves: 0.5,
      );

      expect(pet.fitnessLevel, 0.5);
      expect(pet.intelligenceLevel, 0.5);
      expect(pet.energyReserves, 0.5);
    });

    test('should throw ArgumentError if fitnessLevel is invalid', () {
      expect(
        () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: 1.1,
          intelligenceLevel: 0.5,
          energyReserves: 0.5,
        ),
        throwsArgumentError,
      );
      expect(
        () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: -0.1,
          intelligenceLevel: 0.5,
          energyReserves: 0.5,
        ),
        throwsArgumentError,
      );
    });

    test('should throw ArgumentError if intelligenceLevel is invalid', () {
      expect(
        () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: 0.5,
          intelligenceLevel: 1.1,
          energyReserves: 0.5,
        ),
        throwsArgumentError,
      );
      expect(
         () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: 0.5,
          intelligenceLevel: -0.1,
          energyReserves: 0.5,
        ),
        throwsArgumentError,
      );
    });

    test('should throw ArgumentError if energyReserves is invalid', () {
      expect(
        () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: 0.5,
          intelligenceLevel: 0.5,
          energyReserves: 1.1,
        ),
        throwsArgumentError,
      );
      expect(
         () => PetEntity(
          hunger: 0.5,
          happiness: 0.5,
          energy: 0.5,
          lastUpdate: now,
          fitnessLevel: 0.5,
          intelligenceLevel: 0.5,
          energyReserves: -0.1,
        ),
        throwsArgumentError,
      );
    });

    test('copyWith should return a new instance with updated values', () {
      final pet = PetEntity(
        hunger: 0.5,
        happiness: 0.5,
        energy: 0.5,
        lastUpdate: now,
        fitnessLevel: 0.5,
        intelligenceLevel: 0.5,
        energyReserves: 0.5,
      );

      final updatedPet = pet.copyWith(
        fitnessLevel: 0.8,
        intelligenceLevel: 0.9,
      );

      expect(updatedPet.fitnessLevel, 0.8);
      expect(updatedPet.intelligenceLevel, 0.9);
      expect(updatedPet.energyReserves, 0.5); // Unchanged
      expect(updatedPet.hunger, 0.5); // Unchanged
    });
  });
}
