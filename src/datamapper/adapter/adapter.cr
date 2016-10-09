module DataMapper
  abstract class Adapter
    abstract def initialize(uri)
    abstract def command(cmd : Symbol, repo : Repository, **opts)
    abstract def commands : Array(Symbol)
  end
end
