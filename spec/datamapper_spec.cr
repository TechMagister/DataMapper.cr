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
    (user.responds_to? :"id=").should(be_false)
    user.name = "Username"
    user.pass = "pass"

    user.id.should(be_nil)
    user.name.should(eq("Username"))
    user.pass.should(eq("pass"))
  end

  it "should define from_orm method with arguments" do
    user = User.new
    user.from_orm id: 1, name: "Username", pass: "pass"
    user.id.should(eq(1))
    user.name.should(eq("Username"))
    user.pass.should(eq("pass"))
  end

  it "should define from_orm method with hash" do
    user = User.new
    user.from_orm 1, {"id" => 1, "name" => "Username", "pass" => "pass"}
    user.id.should(eq(1))
    user.name.should(eq("Username"))
    user.pass.should(eq("pass"))
  end
end
