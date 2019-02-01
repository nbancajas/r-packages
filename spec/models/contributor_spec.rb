require 'rails_helper'

describe Contributor do
  describe "#name_with_email" do
    let(:email) { "abc@def.com" }
    let(:name)  { "Abc Def" }

    subject { Contributor.new(name: name, email: email).name_with_email }

    it "returns expected format" do
      expect(subject).to eq "#{name} <#{email}>"
    end
  end
end
