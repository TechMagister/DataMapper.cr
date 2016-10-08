require "spec"
require "../src/datamapper"

class User
  DataMapper.map({
      :name => {:type => String?},
      :pass => {:type => String?}
      })
end

class UserRepo < DataMapper::Repository(User)
end