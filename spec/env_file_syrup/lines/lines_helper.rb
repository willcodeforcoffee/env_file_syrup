RSpec.shared_examples "a line" do |line|
  describe "#clone" do
    it "is implemented" do
      expect { line.clone }.not_to raise_error(NotImplementedError)
    end

    it "returns a new instance of the same class" do
      expect(line.clone).to be_a(line.class)
    end

    it "returns a new copy of the class" do
      expect(line.clone).not_to be(line)
    end

    it "has the same #to_s result as the original" do
      expect(line.clone.to_s).to eq line.to_s
    end
  end

  describe "#to_s" do
    it "is implemented" do
      expect { line.to_s }.not_to raise_error(NotImplementedError)
    end
  end
end
