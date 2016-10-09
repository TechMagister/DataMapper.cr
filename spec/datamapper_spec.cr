require "./spec_helper"

describe DataMapper do
  it "should create getters" do
    user = User.new

    user.id.should(be_nil)
    user.name.should(be_nil)
    user.pass.should(be_nil)
  end

  it "should create setters except for id" do
    user = User.new
    user.name = "Username"
    user.pass = "pass"

    user.id.should(be_nil)
    user.name.should(eq("Username"))
    user.pass.should(eq("pass"))
  end
end
