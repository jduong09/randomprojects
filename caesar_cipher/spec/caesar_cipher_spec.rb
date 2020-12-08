require "./lib/caesar_cipher"

# tests go here

describe "#caesar_cipher" do
  it "works as intended when given non-letters" do
    example = caesar_cipher("What a string!", 5)
    expect(example).to eql("Bmfy f xywnsl!")
  end

  it "works as intended when given only letters" do
    example = caesar_cipher("Whatastring", 5)
    expect(example).to eql("Bmfyfxywnsl")
  end

  it "works as intended when given a mix of capitalized and non-capitalized letters" do
    example = caesar_cipher("wHaTaString", 5)
    expect(example).to eql("bMfYfXywnsl")
  end

  it "returns same string when skip integer is 0" do
    example = caesar_cipher("What a string!", 0)
    expect(example).to eql("What a string!")
  end
end