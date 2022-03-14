# frozen_string_literal: true

class Skill < ApplicationRecord
  belongs_to :skillgroup
  belongs_to :resttype
  belongs_to :skilldelivery, optional: true
  has_many :characterskills
  has_many :skillrequirements
  has_many :skillrequirements, foreign_key: 'requiredskill_id'

  default_scope { order(tier: :asc, skillgroup_id: :asc, name: :asc) }

  def get_name(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Adara'
            return 'Divine Reckoning'
          when 'Amitel'
            return 'Aether Bend'
          when 'Dedrot'
            return 'Speak With Dead'
          when 'Enoon'
            return 'Mulch'
          when 'Ixbus'
            return "Artisan's Devotion"
          when 'Naenya'
            return 'Shooting Star'
          when 'Ororo'
            return 'Fueled by the Storm'
          when 'Ryknos'
            return 'Last Stand'
          when 'Scandelen'
            return 'Sacred Toast'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara'
            return 'Aforetime Blessing'
          when 'Amitel'
            return 'Magic Missile'
          when 'Dedrot'
            return 'Stop the Horde'
          when 'Enoon'
            return 'Raise Earth'
          when 'Ixbus'
            return 'Fruis of the Labor'
          when 'Naenya'
            return 'Dark Strike'
          when 'Ororo'
            return 'Elemental Ward'
          when 'Ryknos'
            return 'War Cry'
          when 'Scandelen'
            return 'Sleep it Off'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara'
            return 'Imprison'
          when 'Amitel'
            return 'Silence'
          when 'Dedrot'
            return 'Through the Veil'
          when 'Enoon'
            return 'One With Nature'
          when 'Ixbus'
            return 'Crafters Muse'
          when 'Naenya'
            return 'Clemency'
          when 'Ororo'
            return 'Unrelenting Storm'
          when 'Ryknos'
            return 'Slay'
          when 'Scandelen'
            return 'Keep the Party Going'
        end

      when 'Divine Aura'
        case character.deity.name
          when 'Adara'
            return 'Aura of the Grace of the Sun'
          when 'Amitel'
            return 'Aura of Potency'
          when 'Dedrot'
            return 'Aura of Bones'
          when 'Enoon'
            return 'Aura of the Forest Walker'
          when 'Ixbus'
            return 'Aura of the Golden Hand'
          when 'Naenya'
            return "Aura of the Moon's Mercy"
          when 'Ororo'
            return 'Aura of the Tempest'
          when 'Ryknos'
            return 'Aura of Blood'
          when 'Scandelen'
            return 'Aura of Purity'
        end

      when 'Divine Archon'
        case character.deity.name
          when 'Adara'
            return 'Aura of the Tribunal'
          when 'Amitel'
            return 'Aura of Endurance'
          when 'Dedrot'
            return 'Soul Veil'
          when 'Enoon'
            return 'Aura of the Sacred Grove'
          when 'Ixbus'
            return 'Aura of Dross'
          when 'Naenya'
            return 'Aura of Abeyance'
          when 'Ororo'
            return 'One With the Storm'
          when 'Ryknos'
            return 'Aura of the Champion'
          when 'Scandelen'
            return 'Bastion of the Arts'
        end

      when 'Totemic Gift'
        case character.totem
          when 'Bear'
            return 'Ancient Vitality'
          when 'Lizard'
            return 'Regeneration'
          when 'Rat'
            return 'Plaguerat'
          when 'Raven'
            return 'Collector of Stories'
          when 'Snake'
            return 'Spitting Cobra'
          when 'Spider'
            return 'Web-shooter'
          when 'Wolf'
            return 'Strength of the Pack'
        end
      when 'Totemic Blessing'
        case character.totem
          when 'Bear'
            return 'Unstoppable'
          when 'Lizard'
            return 'Reconstruction:'
          when 'Rat'
            return 'Contagion'
          when 'Raven'
            return 'Collector of Secrets'
          when 'Snake'
            return 'Deadly Venom'
          when 'Spider'
            return 'Widows Bite'
          when 'Wolf'
            return 'Pack Tactics'
        end
    else
      return self.name
    end
  end

  def get_description(character)
    case self.name
    when 'Channel Divinity'
      case character.deity.name
        when 'Adara'
          return 'Day Only - State, "Through Adara, Crit Damage 5!"'
        when 'Amitel'
          return 'You may cast any single damage spell through an alternative alignment of your choice. "<Arcane, Water, Earth, Wind, Fire, Wood, Spirit or Mind>"'
        when 'Dedrot'
          return '"Through Spirit, I speak with the dead."'
        when 'Enoon'
          return '“By My Voice, Through Water, I end your death count.” Then restore one Tier 1-3 Life Spell.'
        when 'Ixbus'
          return 'You may now learn a maximum of 2 Profession Skills per game session.'
        when 'Naenya'
          return 'Night Only - “Through Naenya, Crit Damage 5.”'
        when 'Ororo'
          return 'Choose an element. (Earth, Fire, Water, Wind, Wood) For 5 minutes, spell damage from that element will instead heal an equal amount of Hit Points. State, “Resist,” then “heal,” <Number of Called Damage> resisted.'
        when 'Ryknos'
          return 'When you drop to zero Hit Points, you may choose to activate
          this skill. This ability heals you to full Hit Points. After
          30 seconds, you will instantly drop back to zero Hit
          Points.'
        when 'Scandelen'
          return 'Roleplay Required: One Minute pouring drink out of the bottle
          and raising the glasses while making a brief speech.
          “Through Scandelen, Heal 5 Hit Points.” This ability
          may affect up to 5 individuals.'
      end

    when 'Channel Inspiration'
      case character.deity.name
        when 'Adara'
          return 'Roleplay Required: 2 minutes of giving a rousing speech or going over
          the plans before an adventure. Then state, “Through
          Adara, Divine Blessing, should you die in the next
          hour, inform Dedrot’s Barristers that you are Divinely
          Blessed.” Touch up to five targets.'
        when 'Amitel'
          return '“Through Arcane, Damage 1.”'
        when 'Dedrot'
          return 'Packet Chain - “Through Spirit, Paralyze to Undead.”'
        when 'Enoon'
          return '“Through Earth, Damage 2.”'
        when 'Ixbus'
          return 'You may expend 2 Labor to receive a random component.'
        when 'Naenya'
          return 'Night Only “Through Spirit, Bestow Dark Strike, state ‘Crit’ on your next called strike.”'
        when 'Ororo'
          return 'You may Resist a spell cast through the elements (earth, fire, water, wind, or wood).'
        when 'Ryknos'
          return '“By Voice, Through Ryknos, Dispel Pacify.” Special: You
          may cast this spell while under the effects of Pacify.'
        when 'Scandelen'
          return '“By Scandelen, Sleep 5 Minutes. Pause your Poison
          count. If you reach the end of Sleep’s duration
          uninterrupted, Heal 5 Hit Points, Cure Poison, and
          Cure Disease, and Bestow 5 Temporary Hit Points.”'
      end

    when 'Channel Inspiration'
      case character.deity.name
        when 'Adara'
          return '"Through Fire, Paralyze 1 Minute.”'
        when 'Amitel'
          return '"Through Mind, Silence.”'
        when 'Dedrot'
          return 'When your death count ends, you may remain on the
          battlefield as a spirit if you so choose. While there, you
          may cast any remaining Life spells you possess. State
          “Resist” to any effect that targets you during this time.
          You may remain on the field up to a minute or until
          the battle ends, whichever comes first. At the end of
          that time, you proceed directly to Dedrot’s realm.'
        when 'Enoon'
          return 'Deep Woods Only - When you complete a Short Rest,
          restore yourself to full Hit Points.'
        when 'Ixbus'
          return '“Through Ixbus, Bestow 4 Temporary Labor until your
          next Long Rest”. You may touch up to 5 individuals.'
        when 'Naenya'
          return '“Through Naenya, Cure Final Judgement,
          you now have a divine blessing, tell Dedrot’s Barrister
          of your blessing.”'
        when 'Ororo'
          return 'Packet Chain - Choose an Element (Earth, Fire, Wind, Water,
          Wood) State, “Through <Element>, Damage 2.”'
        when 'Ryknos'
          return '“Death.”'
        when 'Scandelen'
          return 'After 2 minutes of Inspirational RP restore all Short
          Rest skills of up to 5 people.'
      end

    when 'Divine Aura'
      case character.deity.name
        when 'Adara'
          return 'Outside Only - Day Only - You and your Benefactors
          may pause your bleed-out count if you are knocked
          unconscious from damage. You may end your bleed-out
          count at any time and start your death count.'
        when 'Amitel'
          return 'Benefactors may increase the damage of all damage spells they cast by 1.'
        when 'Dedrot'
          return 'Benefactors may state, “Disengage to Undead” on all weapon strikes.'
        when 'Enoon'
          return 'Deep Woods Only - You and your Benefactors may pause
          your bleed-out count if you are knocked unconscious
          from damage. You may end your bleed-out count at
          any time and start your death count. If this would pause
          your time until the game is off, you must go directly to
          Dedrot’s realm at the start of the next game day.'
        when 'Ixbus'
          return 'Benefactors gain unlimited use of the skill Rapid Search.'
        when 'Naenya'
          return 'Outside Only - Night Only - You and your Benefactors may
          pause your bleed-out count if you are knocked
          unconscious from damage. You may end your bleedout
          count at any time and start your death count. If this
          would pause your time until the game is off, you must
          go directly to Dedrot’s realm at the start of the next
          game day.'
        when 'Ororo'
          return 'Benefactors may state “Resist” to missile weapons.'
        when 'Ryknos'
          return 'Benefactors may state, “I Heal myself 1 Hit Point” when they successfully
          render an enemy unconscious through a weapon strike.'
        when 'Scandelen'
          return 'Benefactors may state, “Resist” to poison.'
      end

    when 'Divine Archon'
      case character.deity.name
        when 'Adara'
          return 'If the majority
          of your Benefactors agree verbally to the guilt of the
          accused, you may grant the accused a Final Judgement.
          You must use a minimum of four Benefactors to gain
          the effect. Touch the target corpse and state, “Through
          Spirit, I curse you in the name of Adara. Inform the
          Barrister in Dedrot’s Realm of your curse.”'
        when 'Amitel'
          return 'Benefactors may double the duration of spells they cast.'
        when 'Dedrot'
          return 'Benefactors may state, “Resist” to all Non-Damage effects from Undead.'
        when 'Enoon'
          return 'You and your Benefactors “Resist” non-damaging effects from
          beasts.'
        when 'Ixbus'
          return 'Benefactors may state “you find nothing” when searched. Being Unconscious does not end this effect.'
        when 'Naenya'
          return 'Benefactors may state, “Resist” to Curse effects. This aura does not
          remove curses gained before being under the influence
          of the aura.'
        when 'Ororo'
          return 'When selecting Benefactors: Choose Fire, Earth, Water, Wind, or Wood. Treat the damage you receive from that type as a Heal for the same amount.'
        when 'Ryknos'
          return 'When a Benefactor successfully renders an enemy unconscious
          through a weapon strike, they may state, “Restore
          <Skill>” and restore the use of any single tier 1-3
          weapon skill.'
        when 'Scandelen'
          return 'Bardic Benefactors gain two additional patrons. You receive
          the benefits of being the Benefactor of one of your
          bardic patrons without counting as a patron.'
      end

    when 'Totemic Gift'
      case character.totem
        when 'Bear'
          return 'Gain +2 Hit Points'
        when 'Lizard'
          return 'Self Only - Heal all Hit Points'
        when 'Rat'
          return '“Disease.”'
        when 'Raven'
          return 'At check-in, you may
          collect a list of current event rumors. The number you
          receive may vary.'
        when 'Snake'
          return 'You may state the Hurl effect of a potion and throw it as a packet'
        when 'Spider'
          return '"Bind"'
        when 'Wolf'
          return '“Damage 6.”'
      end
    when 'Totemic Blessing'
      case character.totem
        when 'Bear'
          return 'You may state “Resist” to Paralyze, Slow, Root, Pacify, or Bind Legs'
        when 'Lizard'
          return 'When you complete a short rest, you heal to your maximum hit points and are cured of all maimed limbs and disease'
        when 'Rat'
          return 'When touched through a Touch Spell or when searched, you may state “To you, Disease”'
        when 'Raven'
          return 'Prop Required: Something connected to the person, place,
          or object - You may ask a single question concerning
          a person, place, or object. The more focused your
          question regarding that person, place, or item, the more
          information you will receive at the following check-in'
        when 'Snake'
          return 'Reduce a Poison time from an item or skill you use to 10 seconds'
        when 'Spider'
          return 'Armament - Dagger or Ranged Weapon. “Crit Death”'
        when 'Wolf'
          return '“When you cast a use of a “Bestow” spell you know on another Wolf Druid, you may also gain the Bestow effect”'
      end
      
    else
      return self.description
    end
  end

  def get_resttype(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Adara', 'Amitel', 'Naenya', 'Scandelen'
            return 'Short Rest'
          when 'Dedrot', 'Ixbus'
            return 'Permanent'
          when 'Enoon', 'Ororo', 'Ryknos'
            return 'Long Rest'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Enoon', 'Naenya', 'Ororo', 'Scandelen'
            return 'Short Rest'
          when 'Adara', 'Dedrot', 'Ryknos'
            return 'Long Rest'
          when 'Amitel'
            return 'Permanent'
          when 'Ixbus'
            return 'Event '
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Amitel'
            return 'Short Rest'
          when 'Adara', 'Ixbus', 'Naenya', 'Ororo', 'Ryknos', 'Scandelen'
            return 'Long Rest'
          when 'Dedrot', 'Enoon'
            return 'Permanent'
        end

      when 'Divine Aura'
        return 'Aura'
      when 'Divine Archon'
        return 'Aura'

      when 'Totemic Gift'
        case character.totem
          when 'Bear'
            return 'Permanent'
          when 'Lizard', 'Rat', 'Snake', 'Spider', 'Wolf'
            return 'Short Rest'
          when 'Raven'
            return 'Event'
        end
      when 'Totemic Blessing'
        case character.totem
          when 'Wolf'
            return 'Permanent'
          when 'Bear', 'Lizard', 'Rat'
            return 'Short Rest'
          when 'Snake', 'Spider'
            return 'Long Rest'
          when 'Raven'
            return 'Between Events'
        end

    else
      return self.resttype.name
    end
  end

  def get_incant(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Adara'
            return 'Through Adara, Crit Damage 5'
          when 'Dedrot'
            return 'Through Spirit, I speak with the dead.'
          when 'Enoon'
            return 'By My Voice, Through Water, I end your death count.'
          when 'Naenya'
            return 'Through Naenya, Crit Damage 5'
          when 'Scandelen'
            return 'Through Scandelen, Heal 5 Hit Points'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara'
            return 'Through Adara, Divine Blessing, should you die in the next
            hour, inform Dedrot’s Barristers that you are Divinely Blessed'
          when 'Amitel'
            return 'Through Arcane, Damage 1'
          when 'Dedrot'
            return 'Through Spirit, Paralyze to Undead'
          when 'Enoon'
            return 'Through Earth, Damage 2'
          when 'Naenya'
            return "Through Spirit, Bestow Dark Strike, state 'Crit' on your next called strike"
          when 'Ryknos'
            return 'By Voice, Through Ryknos, Dispel Pacify.'
          when 'Scandelen'
            return 'By Scandelen, Sleep 5 Minutes. Pause your Poison
            count. If you reach the end of Sleeps duration
            uninterrupted, Heal 5 Hit Points, Cure Poison, and
            Cure Disease, and Bestow 5 Temporary Hit Points'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara'
            return 'Through Fire, Paralyze 1 Minute'
          when 'Amitel'
            return 'Through Mind, Silence'
          when 'Ixbus'
            return 'Through Ixbus, Bestow 4 Temporary Labor until your next Long Rest'
          when 'Naenya'
            return "Through Naenya, Cure Final Judgement, you now have a divine blessing, tell Dedrot's Barrister of your blessing"
          when 'Ororo'
            return 'Through <Element>, Damage 2'
          when 'Ryknos'
            return 'Death'
        end

      when 'Totemic Gift'
        case character.totem
          when 'Rat'
            return 'Disease'
          when 'Spider'
            return 'Bind Arms and Legs'
          when 'Wolf'
            return 'Damage 6'
        end
      when 'Totemic Blessing'
        case character.totem
          when 'Rat'
            return 'To you, Disease'
          when 'Spider'
            return 'Crit Death'
        end
    else
      return self.incant
    end
  end

  def get_prop(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Scandelen'
            return 'A Bottle decorated for Scandelen'
        end

      when 'Totemic Blessing'
        case character.totem
          when 'Spider'
            return 'Dagger or Ranged Weapon'
        end

    else
      return self.prop
    end
  end

  def get_target(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Dedrot'
            return 'Corpse Only'
          when 'Ryknos'
            return 'Self Only'
          when 'Scandelen'
            return 'Up to 5 People'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara'
            return 'Up to 5 People'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Dedrot'
            return 'Self Only'
          when 'Ixbus'
            return 'Up to 5 People'
          when 'Naenya'
            return 'Corpse Only'
          when 'Scandelen'
            return 'Up to 5 People'
        end

      when 'Totemic Gift'
        case character.totem
          when 'Lizard'
            return 'Self Only'
        end
      when 'Totemic Blessing'
        case character.totem
          when 'Wolf'
            return 'Another Wolf Druid'
        end
    else
      return self.target
    end
  end

  def get_delivery(character)
    case self.name
      when 'Channel Divinity'
        case character.deity.name
          when 'Adara', 'Amitel', 'Naenya'
            return 'Packet'
          when 'Dedrot', 'Scandelen'
            return 'Touch'
          when 'Enoon'
            return 'Voice'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Amitel', 'Naenya'
            return 'Packet'
          when 'Scandelen'
            return 'Touch'
          when 'Ryknos'
            return 'Voice'
          when 'Dedrot'
            return 'Chain'
          when 'Enoon'
            return 'Burst'
        end

      when 'Channel Inspiration'
        case character.deity.name
          when 'Adara', 'Amitel'
            return 'Packet'
          when 'Ixbus', 'Naenya', 'Scandelen'
            return 'Touch'
          when 'Ryknos'
            return 'Weapon'
          when 'Ororo'
            return 'Chain'
        end

      when 'Divine Aura'
        return 'Aura'
      when 'Divine Archon'
        return 'Aura'

      when 'Totemic Gift'
        case character.totem
          when 'Rat'
            return 'Weapon'
          when 'Spider'
            return 'Packet'
          when 'Wolf'
            return 'Weapon'
        end
      when 'Totemic Blessing'
        case character.totem
          when 'Spider'
            return 'Weapon'
        end

    else
      if !self.skilldelivery.nil?
        return self.skilldelivery.name
      end
    end
  end

end
