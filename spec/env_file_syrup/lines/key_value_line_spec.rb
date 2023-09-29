require_relative "lines_helper"

RSpec.describe EnvFileSyrup::Lines::KeyValueLine do
  it_behaves_like "a line", described_class.new("KEY", "value", "comment")

  describe "#merge" do
    subject(:merged) { original.merge(merger) }

    let(:original) { described_class.new("KEY", "old value", "old comment") }
    let(:merger) { described_class.new("KEY", "new value") }

    context "when given a KeyValueLine with a different value but no comment" do
      it "changes value to the merged value" do
        expect(merged.value).to eq merger.value
      end

      it "does not change the comment" do
        expect(merged.comment).to eq original.comment
      end
    end

    context "when given a KeyValueLine with a different value and different comment" do
      let(:merger) { described_class.new("KEY", "new value", "new comment") }

      it "changes value to the merger value" do
        expect(merged.value).to eq merger.value
      end

      it "changes change to the merger comment" do
        expect(merged.comment).to eq merger.comment
      end
    end
  end
end
