require "json"

module DataMapper
  macro memory_adapter(properties)

    def initialize(%fields : JSON::Type)
      if %fields.is_a? Hash(String, JSON::Type)
        {% for name, opts in properties %}
          self.{{name.id}} = if (f=%fields["{{name.id}}"]?) && f.is_a?({{opts[:type]}}); f end
        {% end %}
      end
    end

  end

  class MemoryAdapter < Adapter
    alias Store = Hash(Int64, Hash(String, JSON::Type))
    alias Storage = Hash(String, Store)
    alias DataBase = Hash(String, Storage)

    @@databases = DataBase.new
    @@actual_id : Int64 = 0i64
    @db_name : String

    def initialize(@uri : String)
      @db_name = if (match = uri.match(/memory:\/\/([a-z]+)/))
                   match[1]
                 else
                   "default"
                 end
      @@databases[@db_name] = Storage.new unless @@databases[@db_name]?
    end

    def command(cmd : Symbol, repo : Repository, **opts)
      case cmd
      when :get  then get(repo, **opts)
      when :save then save(repo, **opts)
      else
        raise Exception.new("Invalid command")
      end
    end

    def save(repo : Repository, **fields) : Int64
      @@actual_id += 1
      hash = Hash(String, JSON::Type).new
      fields.each do |key, value|
        hash[key.to_s] = value.as JSON::Type if value.is_a? JSON::Type
      end
      @@databases[@db_name][repo.config[:storage]] ||= Store.new
      @@databases[@db_name][repo.config[:storage]][@@actual_id] = hash
      return @@actual_id
    end

    def get(repo : Repository, **fields)
      if id = fields[:id]?
        obj = @@databases[@db_name][repo.config[:storage]][id]
        obj["id"] = id if id.is_a? Int64
        obj
      end
    end

    def commands : Array(Symbol)
      [:save, :get]
    end
  end
end
