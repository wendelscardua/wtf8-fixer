require 'spec_helper'
require 'wtf8-fixer'

describe WTF8Fixer do
  let!(:ascii_string) { "coffee coffee" }
  let!(:utf8_string) { "café café" }
  let!(:iso_string) { "café café".encode('iso-8859-1') }
  let!(:broken_string) { "café " + "café".encode('iso-8859-1').force_encoding('utf-8') }
  let!(:worse_string) { "café".encode('iso-8859-1').force_encoding('utf-8') + " café" }

  it "preserves ascii strings" do
    expect(WTF8Fixer.fix(ascii_string)).to eq(ascii_string)
  end

  it "preserves unicode strings" do
    expect(WTF8Fixer.fix(utf8_string)).to eq(utf8_string)
  end

  it "converts iso-8859-1 strings to utf8" do
    expect(WTF8Fixer.fix(iso_string)).to eq(utf8_string)
  end

  it "converts mixed strings (iso-8859-1 + utf8) to utf8" do
    expect(WTF8Fixer.fix(broken_string)).to eq(utf8_string)
    expect(WTF8Fixer.fix(worse_string)).to eq(utf8_string)
  end
end
