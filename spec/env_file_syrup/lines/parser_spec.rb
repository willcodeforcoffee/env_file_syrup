RSpec.describe EnvFileSyrup::Lines::Parser do
  # Invalid Lines
  [
    "Wierd stuff here",
    "  HELP"
  ].each do |line|
    context "when given invalid line: [#{line}]" do
      it "should parse to nil" do
        expect(EnvFileSyrup::Lines::Parser.parse(line)).to be_nil
      end
    end
  end

  # Blank Lines
  ["", "  ", "   ", "\t", "\r", " \n", "\r\n"].each do |line|
    context "when given a blank line" do
      it "should parse to a EnvFileSyrup::Lines::BlankLine" do
        expect(EnvFileSyrup::Lines::Parser.parse(line)).to be_a(EnvFileSyrup::Lines::BlankLine)
      end
    end
  end

  # Comment Lines
  [
    "# This is a comment",
    " # This is a weird comment",
    " # This is a weirder comment"
  ].each do |line|
    context "when given a comment line: [#{line}]" do
      it "should parse to a EnvFileSyrup::Lines::CommentLine" do
        expect(EnvFileSyrup::Lines::Parser.parse(line)).to be_a(EnvFileSyrup::Lines::CommentLine)
      end

      it "should export to a clean comment" do
        expect(EnvFileSyrup::Lines::Parser.parse(line).to_s).to eq line.strip
      end
    end
  end

  # Valid KEY=value Lines
  [
    "KEY=value",
    "KEY=\"value\"",
    "KEY = value",
    "KEY = \"value\"",
    "KEY = 'value'"
  ].each do |line|
    it "should parse to a EnvFileSyrup::Lines::KeyValueLine" do
      expect(EnvFileSyrup::Lines::Parser.parse(line)).to be_a(EnvFileSyrup::Lines::KeyValueLine)
    end

    it "should parse key" do
      expect(EnvFileSyrup::Lines::Parser.parse(line).key).to eq "KEY"
    end

    it "should parse value" do
      expect(EnvFileSyrup::Lines::Parser.parse(line).value).to eq "value"
    end

    it "should export a clean key/value pair" do
      expect(EnvFileSyrup::Lines::Parser.parse(line).to_s).to eq "KEY=value"
    end
  end
end
