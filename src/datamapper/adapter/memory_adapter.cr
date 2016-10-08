require "json"

module DataMapper

  class MemoryAdapter < Adapter
  
  	alias Store = Hash(Int32, Hash(String, JSON::Type))
    alias Storage = Hash(String, Store)
    alias DataBase = Hash(String, Storage)

    @@databases = DataBase.new
  	@@actual_id = 0
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
        when :get then get(repo, **opts)
      	when :create then create(repo, **opts)
    	end
    end
    
    def create(repo : Repository, **fields)
      @@actual_id += 1
      hash = Hash(String, JSON::Type).new
      fields.each do |key, value|
        hash[key.to_s] = value
      end
      @@databases[@db_name][repo.config[:storage]] ||= Store.new
      @@databases[@db_name][repo.config[:storage]][@@actual_id] = hash
      return @@actual_id
    end

    def get(repo : Repository, **fields)
      if id = fields[:id]?
        @@databases[@db_name][repo.config[:storage]][id]
      end
    end
  
  	def commands : Array(Symbol)
    	[:create, :get]
  	end
  
  end

end