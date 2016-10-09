require "./datamapper/*"

module DataMapper
  # @see crystal-db : /src/db/mapping.cr
  macro map(adapters, properties)

    {% for key, value in properties %}
      {% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
    {% end %}

    {% for key, value in properties %}
      @{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }}

      def {{key.id}}=(_{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }})
        @{{key.id}} = _{{key.id}}
      end

      def {{key.id}}
        @{{key.id}}
      end
    {% end %}

    def initialize(
      {% for name, opts in properties %}
        @{{name.id}} : {{opts[:type]}},
      {% end %}
    )
    end

    def initialize(
      {% for name, opts in properties %}
        {% if !opts[:nilable] %}
          @{{name.id}} : {{opts[:type]}},
        {% end %}
      {% end %}
    )
    end

    {% for adatper in adapters %}
      DataMapper.{{adatper.id}}_adapter({{properties}})
    {% end %}

    def self.fields
      {{properties}}
    end


  end
end
