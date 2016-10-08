module DataMapper
  class Repository(T)
    alias Config = Hash(Symbol, String)
    @model : T.class
    @config : Config
    property :config

    def initialize(@container : DataMapper::Container, @model = T)
      @config = Config.new
      @config[:storage] = @model.to_s.downcase
    end

    def create(**fields)
      id = @container.command(:create, self, **fields)
      model = @model.new
      model.from_orm(id, **fields)
      model
    end

    def get(id)
      obj = @container.command(:get, self, id: id.to_i64)
      if obj.is_a? Hash
        model = @model.new
        model.from_orm(id, obj)
        model
      end
    end
  end
end
