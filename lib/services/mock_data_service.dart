// lib/services/mock_data_service.dart
import '../models/feat_reference.dart';
import '../models/creature_reference.dart';
import '../models/skill_reference.dart';
import '../models/spell_reference.dart';

class MockDataService {
  static List<FeatReference> getMockFeats() => [
    FeatReference(
      sectionId: 1,
      database: 'core',
      name: 'Power Attack',
      url: '/feats/power-attack',
      description: 'You can make exceptionally deadly melee attacks...',
      typeLine: 'Combat',
      subtype: null,
      prerequisites: 'Str 13',
    ),
    FeatReference(
      sectionId: 2,
      database: 'core',
      name: 'Toughness',
      url: '/feats/toughness',
      description: 'You have enhanced physical stamina.',
      typeLine: 'General',
      subtype: null,
      prerequisites: null,
    ),
  ];

  static List<CreatureReference> getMockCreatures() => [
    CreatureReference(
      sectionId: 3,
      database: 'bestiary',
      name: 'Goblin',
      url: '/creatures/goblin',
      challengeRating: 0,
      experience: 135,
      size: 'Small',
      alignment: 'Neutral Evil',
      type: 'Humanoid',
      subtype: 'Goblinoid',
    ),
    CreatureReference(
      sectionId: 4,
      database: 'bestiary',
      name: 'Fire Elemental (Medium)',
      url: '/creatures/fire-elemental',
      challengeRating: 3,
      experience: 800,
      size: 'Medium',
      alignment: 'Neutral',
      type: 'Elemental',
      subtype: 'Fire',
    ),
  ];

  static List<SkillReference> getMockSkills() => [
    SkillReference(
      sectionId: 5,
      database: 'core',
      name: 'Stealth',
      url: '/skills/stealth',
      description:
          'You can move silently and stay hidden from view...',
      attribute: 'Dexterity',
      armorCheckPenalty: true,
      trainedOnly: false,
    ),
    SkillReference(
      sectionId: 6,
      database: 'core',
      name: 'Spellcraft',
      url: '/skills/spellcraft',
      description: 'You can identify spells as they are cast...',
      attribute: 'Intelligence',
      armorCheckPenalty: false,
      trainedOnly: true,
    ),
  ];
  
  static List<SpellReference> getMockSpells() => [
    SpellReference(
      sectionId: 7,
      database: 'core',
      name: 'Fireball',
      url: '/spells/fireball',
      description: 'A burst of fire explodes, dealing 1d6 damage per caster level.',
      school: 'Evocation',
      subschool: null,
      descriptor: 'Fire',
      level: 3,
      classes: 'Sorcerer/Wizard',
    ),
    SpellReference(
      sectionId: 8,
      database: 'core',
      name: 'Cure Light Wounds',
      url: '/spells/cure-light-wounds',
      description: 'Heals 1d8 points of damage +1 per caster level (max +5).',
      school: 'Conjuration',
      subschool: 'Healing',
      descriptor: null,
      level: 1,
      classes: 'Cleric, Bard, Paladin',
    ),
  ];

  
}
