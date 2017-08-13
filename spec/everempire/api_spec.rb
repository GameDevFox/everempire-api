require "spec_helper"

RSpec.describe EverEmpire::API do
  it "has a version number" do
    expect(EverEmpire::API::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
