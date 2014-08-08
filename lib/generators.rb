# Based (heavily) on the original name generator on Github: Daiz-/xcom-namegen
module Generators

  COUNTRIES = %w(Am Rs Ch In Af Mx Ab En Fr Gm Au It Jp Is Es Gr Nw Ir Sk Du Sc Bg Pl)
  DOUBLED_COUNTRIES = %w(Rs Pl)

  def Generators.classic(names)
    if names.nil?
      names = ['Fuzzy Kalimag', 'Doc Brown'] # Sample data!
    else
      names = __sanitise_input_string(names)
    end

    out = "[XcomGame.XGCharacterGenerator]\n" \
          "; Generated by XCOM Name Generator (Classic-mode)\n\n"

    # Blank out first names
    COUNTRIES.each do |c|
      out += "m_arr#{c}MFirstNames=\"\"\n" \
             "m_arr#{c}FFirstNames=\"\"\n"
    end

    # Process names as 'surnames'
    out += __process_second_names(names)

    out.gsub("\n", "\r\n")
  end

  def Generators.modern(firsts_m, firsts_f, seconds, mixeds_m, mixeds_f)
    if firsts_m.nil? or firsts_f.nil? or seconds.nil?
      raise Exception('Parameter not specified.')
    else
      firsts_m = __sanitise_input_string(firsts_m)
      firsts_f = __sanitise_input_string(firsts_f)
      seconds = __sanitise_input_string(seconds)
      mixeds_m = __sanitise_input_string(mixeds_m)
      mixeds_f = __sanitise_input_string(mixeds_f)
    end

    out = "[XcomGame.XGCharacterGenerator]\n" \
          "; Generated by XCOM Name Generator (Modern-mode)\n\n"

    # Let's begin! First names first.
    out += __process_first_names(firsts_m, 'M')
    out += __process_first_names(firsts_f, 'F')

    # Next up, second names. We ignore double countries (Poland/Russia).
    out += __process_second_names(seconds)

    # Handle the mixed names.
    mixed_m_firsts = []
    mixed_f_firsts = []
    mixed_seconds = []
    rnd = Random.new

    mixeds_m.each do |n|
      v = rnd.rand(0..1)
      if v == 0
        mixed_m_firsts << n
      else
        mixed_seconds << n
      end
    end

    mixeds_f.each do |n|
      v = rnd.rand(0..1)
      if v == 0
        mixed_f_firsts << n
      else
        mixed_seconds << n
      end
    end

    out += __process_first_names(mixed_m_firsts, 'M')
    out += __process_first_names(mixed_f_firsts, 'F')
    out += __process_second_names(mixed_seconds)

    out.gsub("\n", "\r\n")
  end

  # Parse a string from Sinatra and chomp it to remove stray newlines
  def Generators.__sanitise_input_string(str)
    if str.nil?
      return []
    end
    str.split("\n").map {|s| s.chomp}
  end

  def Generators.__process_first_names(names, gender)
    out = ''
    names.each do |n|
      out += "\n; #{gender}F: #{n}\n"
      COUNTRIES.each do |c|
        out += "m_arr#{c}#{gender}FirstNames=#{n}\n"
      end
    end
    out
  end

  def Generators.__process_second_names(names)
    out = ''
    names.each do |n|
      out += "\n; MS: #{n}\n"
      COUNTRIES.each do |c|
        if DOUBLED_COUNTRIES.include? c
          out += "m_arr#{c}MLastNames=#{n}\n" \
                 "m_arr#{c}FLastNames=#{n}\n"
        else
          out += "m_arr#{c}LastNames=#{n}\n"
        end
      end
    end
    out
  end

  private_class_method :__sanitise_input_string
  private_class_method :__process_first_names
  private_class_method :__process_second_names

end
