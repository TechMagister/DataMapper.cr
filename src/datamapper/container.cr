require "./adapter/*"

module DataMapper
  class Container
    @uri : String
    @adapter_class : DataMapper::Adapter.class
    @adapter : DataMapper::Adapter

    def initialize(@adapter_class, @uri)
      @adapter = @adapter_class.new(@uri)
    end

    def command(cmd : Symbol, repo : Repository, **opts)
      if @adapter.commands.includes?(cmd)
        @adapter.command(cmd, repo, **opts)
      else
        raise Exception.new("Invalid command : " + cmd.to_s)
      end
    end
  end
end
