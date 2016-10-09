require "spec"
require "../src/datamapper"

class User
  DataMapper.map({:sqlite, :memory}, {
    :id   => {:type => Int64, :nilable => true},
    :name => {:type => String, :nilable => true},
    :pass => {:type => String, :nilable => true},
  })
end

class UserRepo < DataMapper::Repository(User)
end
