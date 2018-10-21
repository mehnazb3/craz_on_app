module Constants
  module User
    module Gender
      MALE = 'male'
      FEMALE = 'female'
      TRANSGENDER = 'transgender'

      ALL = [MALE, FEMALE, TRANSGENDER]
    end
  end

  module Item
    module Status
      OPEN = 0
      ABUSED = 1
      DELETED = 2
      NAME_MAP = {
        open: OPEN,
        abused: ABUSED,
        deleted: DELETED
      }
      REV_NAME_MAP = NAME_MAP.invert
    end

    BLACKLISTED_WORDS = ['anal', 'anus', 'arse', 'ass', 'ballsack', 'balls', 'bastard',
                          'bitch', 'biatch', 'bloody', 'blowjob', 'blow job', 'bollock',
                          'bollok', 'boner', 'boob', 'bugger', 'bum', 'butt', 'buttplug',
                          'clitoris', 'cock', 'coon', 'crap', 'cunt', 'damn', 'dick',
                          'dildo', 'dyke', 'fag', 'feck', 'fellate', 'fellatio', 'felching',
                          'fuck', 'f u c k', 'fudgepacker', 'fudge packer', 'flange',
                          'Goddamn', 'God damn', 'hell', 'homo', 'jerk', 'jizz', 'knobend',
                          'knob end', 'labia', 'lmao', 'lmfao', 'muff', 'nigger', 'nigga',
                          'omg', 'penis', 'piss', 'poop', 'prick', 'pube', 'pussy', 'queer',
                          'scrotum', 'sex', 'shit', 's hit', 'sh1t', 'slut', 'smegma',
                          'spunk', 'tit', 'tosser', 'turd', 'twat', 'vagina', 'wank',
                          'whore', 'wtf']
  end
end