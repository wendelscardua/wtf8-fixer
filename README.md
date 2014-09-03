WTF-8 Fixer
===========

Fixes strings, converts them to UTF-8 even when mixed (ISO-8859-1 + UTF-8)

Example:
--------
    
    broken_string = 'café ' + 'café'.encode('iso-8859-1').force_encoding('utf-8'))
    # => "café caf\xE9"

    require 'wtf8-fixer'
    actual_utf8_string = WTF8Fixer.fix(broken_string)    
    # => "café café"

