require "../spec_helper"

container = DataMapper::Container.new(DataMapper::SqliteAdapter, "sqlite3:./spec/test.db")

userRepo = UserRepo.new(container)

describe DataMapper::SqliteAdapter do
  it "should create the table" do
    userRepo.create.should be_true
  end

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

  #it "should update the user" do
  #  if user = userRepo.get(1)
  #    user.name = "NewUsername"
  #    userRepo.update user
  #  end

  #  updated_user = userRepo.get(1)
  #  updated_user.should_not be_nil

  #  if updated_user
  #    updated_user.name.should eq("NewUsername")
  #  end
  #end
end
