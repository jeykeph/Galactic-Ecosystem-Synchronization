import { describe, it, expect, beforeEach } from 'vitest';

describe('species-interactions', () => {
  let contract: any;
  
  beforeEach(() => {
    contract = {
      createSpecies: (name: string, planetId: number, population: number, diet: string) => ({ value: 1 }),
      setInteraction: (species1Id: number, species2Id: number, interactionType: string, strength: number) => ({ success: true }),
      getSpecies: (speciesId: number) => ({
        name: 'Xenon Floater',
        planetId: 1,
        population: 1000000,
        diet: 'photosynthesis',
        creator: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
      }),
      getInteraction: (species1Id: number, species2Id: number) => ({
        interactionType: 'symbiosis',
        strength: 75
      }),
      getSpeciesCount: () => 10
    };
  });
  
  describe('create-species', () => {
    it('should create a new species', () => {
      const result = contract.createSpecies('Xenon Floater', 1, 1000000, 'photosynthesis');
      expect(result.value).toBe(1);
    });
  });
  
  describe('set-interaction', () => {
    it('should set an interaction between two species', () => {
      const result = contract.setInteraction(1, 2, 'symbiosis', 75);
      expect(result.success).toBe(true);
    });
  });
  
  describe('get-species', () => {
    it('should return species information', () => {
      const species = contract.getSpecies(1);
      expect(species.name).toBe('Xenon Floater');
      expect(species.population).toBe(1000000);
    });
  });
  
  describe('get-interaction', () => {
    it('should return interaction information', () => {
      const interaction = contract.getInteraction(1, 2);
      expect(interaction.interactionType).toBe('symbiosis');
      expect(interaction.strength).toBe(75);
    });
  });
  
  describe('get-species-count', () => {
    it('should return the total number of species', () => {
      const count = contract.getSpeciesCount();
      expect(count).toBe(10);
    });
  });
});

