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

    def create
      @container.command :create, self, model: @model
    end

    def save(**fields)
      id = @container.command(:save, self, **fields)
      get(id)
    end

    def update(object : T)
      updated_obj = @container.command(:update, self, object: object)
      updated_obj
    end

    def get(id)
      obj = @container.command(:get, self, id: id)
      model = @model.new obj
      model
    end
  end
end
