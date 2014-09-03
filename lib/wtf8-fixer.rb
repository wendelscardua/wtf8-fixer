class WTF8Fixer
  # Fixes strings, converts to UTF-8 even if mixed (ISO-8859-1 + UTF-8)
  #
  # Example:
  #
  #   >> WTF8Fixer.fix('café ' + 'café'.encode('iso-8859-1').force_encoding('utf-8'))
  #   => 'café café'
  #
  # Arguments:
  #   string: (String)

  def self.fix(string)
    fix_bytes! string.bytes
  end

  private

  def self.fix_bytes!(input)
    buffer = []
    while input.length > 0
      n = num_bits input[0]
      if n <= 1 || n > input.length
        data = iso_to_unicode! input
      else
        data = unicode_to_unicode! input
        if data.size == 0
          data = iso_to_unicode! input
        end
      end
      buffer.push *data
    end

    buffer.pack('C*').force_encoding('utf-8')
  end

  def self.iso_to_unicode!(input)
    current_byte = (input.shift()) & 0xff
    if (current_byte & 0x80) == 0
      current_byte
    else
      [
        0xc0 | ((current_byte >> 6) & 0x1f),
        0x80 | (current_byte & 0x3f)
      ]
    end
  end

  def self.unicode_to_unicode!(input)
    n = num_bits input[0]
    if n == 0
      return input.shift
    elsif n == 1
      return []
    elsif input[1 ... n].any? { |item| (item & 0xc0) != 0x80 }
      return []
    else
      return input.shift(n)
    end
  end

  def self.num_bits(b)
    if (b & 0x80) == 0
      0
    elsif (b & 0xC0) == 0x80
      1
    elsif (b & 0xE0) == 0xC0
      2
    elsif (b & 0xF0) == 0xE0
      3
    elsif (b & 0xF8) == 0xF0
      4
    else
      0
    end
  end

end
