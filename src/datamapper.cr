require "./datamapper/*"

module DataMapper
  macro map(args)

    @id : Int32?

    getter :id

    # arguments
    {% for name, opts in args %}
      @{{name.id}} : {{opts[:type]}}
      property :{{name.id}}
  	{% end %}

    def from_orm(@id, **fields)
      {% for name, opts in args %}
        self.{{name.id}} = fields[:{{name.id}}]?
  		{% end %}
      fields
    end

    def from_orm(@id, fields : Hash)
      {% for name, opts in args %}
        self.{{name.id}} = if (f = fields["{{name.id}}"]?) && (field = f.as? {{opts[:type]}})
          field
        end
  		{% end %}
    end

  end
end
