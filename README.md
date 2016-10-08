# DataMapper

WIP ( Work in progress )

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  datamapper:
    github: TechMagister/DataMapper.cr
```


## Usage


```crystal
require "datamapper"

class User
  DataMapper.map({
      :name => {:type => String?},
      :pass => {:type => String?}
      })
end

class UserRepo < DataMapper::Repository(User)
end

container = DataMapper::Container.new(DataMapper::MemoryAdapter, "memory://test")

userRepo = UserRepo.new(container)

user = userRepo.create(name: "Username", pass: "pass") # User(id: 1, name: "Username", pass: "pass")
user = userRepo.get(1) # User(id: 1, name: "Username", pass: "pass")
```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/TechMagister/DataMapper.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TechMagister](https://github.com/TechMagister) Arnaud Fernandés - creator, maintainer
