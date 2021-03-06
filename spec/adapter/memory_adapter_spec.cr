require "../spec_helper"

container = DataMapper::Container.new(DataMapper::MemoryAdapter, "memory://test")

userRepo = UserRepo.new(container)

describe DataMapper::MemoryAdapter do
  it "should save an entity" do
    user = userRepo.save(name: "Username", pass: "pass")
    user.should_not be_nil
    if user
      user.id.should(eq(1))
      user.name.should(eq("Username"))
      user.pass.should(eq("pass"))
    end
  end

  it "should get the user" do
    user = userRepo.get(1)
    user.should_not(be_nil)
    if user
      user.id.should(eq(1))
      user.name.should(eq("Username"))
      user.pass.should(eq("pass"))
    end
  end
end
