RSpec.describe EnvFileSyrup::EnvFile do
  describe "#parse" do
    let(:valid_env_file) do
      <<~ENV_FILE
        # Comment line
        KEY1=value1
        KEY2=value2 # Comment at end of line

        # A section split content
        KEY3=value3 # Comment on line 3
      ENV_FILE
    end

    it "returns an instance of EnvFile" do
      expect(EnvFileSyrup::EnvFile.parse(valid_env_file)).to be_a(EnvFileSyrup::EnvFile)
    end

    describe "the parsed file" do
      subject { EnvFileSyrup::EnvFile.parse(valid_env_file) }
      let(:line_number) { 0 }
      let(:data_at_line) { EnvFileSyrup::EnvFile.parse(valid_env_file).lines[line_number] }

      it "should parse 6 lines" do
        expect(subject.lines.size).to eq 6
      end

      context "given the first line is a comment" do
        it "should be a CommentLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::CommentLine)
        end

        it "should be the correct comment text" do
          expect(data_at_line.to_s).to eq "# Comment line"
        end
      end

      context "given the second line is a key value pair" do
        let(:line_number) { 1 }

        it "should be a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "should start with the correct key/value" do
          expect(data_at_line.to_s).to eq "KEY1=value1"
        end
      end

      context "given the third line is a key value pair with a comment" do
        let(:line_number) { 2 }

        it "should be a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "should start with the correct key/value and comment" do
          expect(data_at_line.to_s).to eq "KEY2=value2 # Comment at end of line"
        end
      end

      context "given the fourth line is a blank line" do
        let(:line_number) { 3 }

        it "should be a BlankLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::BlankLine)
        end

        it "should be blank" do
          expect(data_at_line.to_s).to eq ""
        end
      end

      context "given the fifth line is a comment" do
        let(:line_number) { 4 }

        context "given the first line is a comment" do
          it "should be a CommentLine" do
            expect(data_at_line).to be_a(EnvFileSyrup::Lines::CommentLine)
          end

          it "should be the correct comment text" do
            expect(data_at_line.to_s).to eq "# A section split content"
          end
        end
      end

      context "given the sixth line is a key value pair with a comment" do
        let(:line_number) { 5 }

        it "should be a KeyValueLine" do
          expect(data_at_line).to be_a(EnvFileSyrup::Lines::KeyValueLine)
        end

        it "should start with the correct key/value and comment" do
          expect(data_at_line.to_s).to eq "KEY3=value3 # Comment on line 3"
        end
      end
    end
  end
end
