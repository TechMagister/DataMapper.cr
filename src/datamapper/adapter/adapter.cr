module DataMapper
  abstract class Adapter
    abstract def initialize(uri)
    abstract def commands : Array(Symbol)
  end
end
