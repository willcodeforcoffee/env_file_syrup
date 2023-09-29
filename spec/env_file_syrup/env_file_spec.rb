RSpec.describe EnvFileSyrup::EnvFile do
  subject(:parsed_file) { described_class.parse(valid_env_file) }

  let(:valid_env_file) do
    <<~ENV_FILE
      # Comment line
      KEY1=value1
      KEY2=value2 # Comment at end of line

      # A section split content
      KEY3=value3 # Comment on line 3
    ENV_FILE
  end

  describe "#parse" do
    it "returns an instance of EnvFile" do
      expect(parsed_file).to be_a(described_class)
    end

    describe "the parsed file" do
      subject(:data_at_line) { parsed_file.lines[line_number] }

      let(:line_number) { 0 }

      it "parses 6 lines" do
        expect(parsed_file.lines.size).to eq 6
      end

      context "when the first line is a comment" do
        it "is a CommentLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::CommentLine)
        end

        it "is the correct comment text" do
          expect(data_at_line.to_s).to eq "# Comment line"
        end
      end

      context "when the second line is a key value pair" do
        let(:line_number) { 1 }

        it "is a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "starts with the correct key/value" do
          expect(data_at_line.to_s).to eq "KEY1=value1"
        end
      end

      context "when the third line is a key value pair with a comment" do
        let(:line_number) { 2 }

        it "is a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "starts with the correct key/value and comment" do
          expect(data_at_line.to_s).to eq "KEY2=value2 # Comment at end of line"
        end
      end

      context "when the fourth line is a blank line" do
        let(:line_number) { 3 }

        it "is a BlankLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::BlankLine)
        end

        it "is blank" do
          expect(data_at_line.to_s).to eq ""
        end
      end

      context "when the fifth line is a comment" do
        let(:line_number) { 4 }

        context "when the first line is a comment" do
          it "is a CommentLine" do
            expect(data_at_line).to be_a(EnvFileSyrup::Lines::CommentLine)
          end

          it "is the correct comment text" do
            expect(data_at_line.to_s).to eq "# A section split content"
          end
        end
      end

      context "when the sixth line is a key value pair with a comment" do
        let(:line_number) { 5 }

        it "is a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "starts with the correct key/value and comment" do
          expect(data_at_line.to_s).to eq "KEY3=value3 # Comment on line 3"
        end
      end
    end
  end

  describe "#[](key)" do
    it "returns value1 for KEY1" do
      expect(parsed_file["KEY1"]).to eq "value1"
    end

    it "returns value2 for KEY2" do
      expect(parsed_file["KEY2"]).to eq "value2"
    end

    it "returns value1 for KEY3" do
      expect(parsed_file["KEY3"]).to eq "value3"
    end

    it "returns nil for UNKNOWN" do
      expect(parsed_file["UNKNOWN"]).to be_nil
    end
  end

  describe "#to_h" do
    subject(:parsed_file_hash) { described_class.parse(valid_env_file).to_h }

    it "has the correct keys" do
      expect(parsed_file_hash.keys).to eq %w[KEY1 KEY2 KEY3]
    end

    (1..3).each do |key_number|
      it "has KEY#{key_number}=value#{key_number}" do
        expect(parsed_file_hash["KEY#{key_number}"]).to eq "value#{key_number}"
      end
    end
  end

  describe "#to_s" do
    it "will output a sanitized version of the env file" do
      expect(parsed_file.to_s).to eq valid_env_file
    end
  end

  describe "#merge" do
    subject(:merged_file) { described_class.parse(primary_env_file).merge(described_class.parse(secondary_env_file)) }

    it "will raise ArgumentError unless passed another EnvFile" do
      expect { parsed_file.merge("failure") }.to raise_error(ArgumentError)
    end

    context "when merging two different EnvFiles" do
      let(:primary_env_file) do
        <<~ENV_FILE
          # Env File 1
          KEY1=value1
          KEY2=value2 # Comment at end of line

          # A section split and content
          KEY3=value3 # Comment on line 3
        ENV_FILE
      end

      let(:secondary_env_file) do
        <<~ENV_FILE
          # Env File 2
          KEY4=value4
        ENV_FILE
      end

      let(:expected_merged_file) do
        <<~ENV_FILE
          # Env File 1
          KEY1=value1
          KEY2=value2 # Comment at end of line

          # A section split and content
          KEY3=value3 # Comment on line 3

          # Env File 2
          KEY4=value4
        ENV_FILE
      end

      it "will merge the two files" do
        expect(merged_file.to_s).to eq expected_merged_file
      end
    end

    context "when merging two similar EnvFiles" do
      let(:primary_env_file) do
        <<~ENV_FILE
          # Env File 1
          KEY1=first1 # no change comment
          KEY2=first2 # Comment at end of line

          # A section split and content
          KEY3=first3 # Comment on line 3
        ENV_FILE
      end

      let(:secondary_env_file) do
        <<~ENV_FILE
          KEY1=second1
          KEY2=second2 # New comment too

          # Env File 2
          KEY4=second4
        ENV_FILE
      end

      let(:expected_merged_file) do
        <<~ENV_FILE
          # Env File 1
          KEY1=second1 # no change comment
          KEY2=second2 # New comment too

          # A section split and content
          KEY3=first3 # Comment on line 3

          # Env File 2
          KEY4=second4
        ENV_FILE
      end

      it "will merge the two files" do
        expect(merged_file.to_s).to eq expected_merged_file
      end
    end
  end
end
