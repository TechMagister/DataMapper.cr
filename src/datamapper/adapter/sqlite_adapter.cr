require "db"
require "sqlite3"

module DataMapper
  macro sqlite_adapter(properties)

    # @see crystal-lang : /src/db/mapping.cr
    def initialize(%rs : ::DB::ResultSet)
      {% for key, value in properties %}
        %var{key.id} = nil
        %found{key.id} = false
      {% end %}

      %rs.move_next

      %rs.each_column do |col_name|
        case col_name
          {% for key, value in properties %}
            when {{value[:key] || key.id.stringify}}
              %found{key.id} = true
              %var{key.id} =
                {% if value[:converter] %}
                  {{value[:converter]}}.from_rs(%rs)
                {% elsif value[:nilable] || value[:default] != nil %}
                  %rs.read(Union({{value[:type]}} | Nil))
                {% else %}
                  %rs.read({{value[:type]}})
                {% end %}
          {% end %}
          else
            %rs.read
        end
      end

      {% for key, value in properties %}
        {% unless value[:nilable] || value[:default] != nil %}
          if %var{key.id}.is_a?(Nil) && !%found{key.id}
            raise ::DB::MappingException.new("missing result set attribute: {{(value[:key] || key).id}}")
          end
        {% end %}
      {% end %}

      {% for key, value in properties %}
        {% if value[:nilable] %}
          {% if value[:default] != nil %}
            @{{key.id}} = %found{key.id} ? %var{key.id} : {{value[:default]}}
          {% else %}
            @{{key.id}} = %var{key.id}
          {% end %}
        {% elsif value[:default] != nil %}
          @{{key.id}} = %var{key.id}.is_a?(Nil) ? {{value[:default]}} : %var{key.id}
        {% else %}
          @{{key.id}} = %var{key.id}.not_nil!
        {% end %}
      {% end %}
    end

  end

  class SqliteAdapter < Adapter

    def initialize(@uri : String)
    end

    def command(cmd : Symbol, repo : Repository, **opts)
      case cmd
      when :create then create(repo, **opts)
      when :save   then save(repo, **opts)
      when :get    then get(repo, **opts)
      else
        raise Exception.new("Invalid command")
      end
    end

    def get(repo : Repository, **options)
      if id = options[:id]?
        statement = String.build do |stmt|
          stmt << "SELECT "
          stmt << "#{repo.config[:storage]}.*"
          stmt << " FROM #{repo.config[:storage]}"
          stmt << " WHERE id=? LIMIT 1"
        end
        with_db { |db| db.query statement, id }
      end
    end

    def create(repo : Repository, **options)
      if (model = options[:model]?)
        fields = model.fields
        sql_fields = fields.map { |name, opts|
          "#{name} #{sqlite_type_for(opts[:type])}" unless name == :id
        }.compact.join(",")
        statement = String.build do |stmt|
          stmt << "CREATE TABLE #{repo.config[:storage]} ("
          stmt << "id INTEGER NOT NULL PRIMARY KEY, "
          stmt << sql_fields
          stmt << ")"
        end
        with_db { |db| db.exec statement }
        return true
      end
      false
    end

    def save(repo : Repository, **fields)
      args = [] of DB::Any
      fields.each { |name, _| args << fields[name].to_s }

      statement = String.build do |stmt|
        stmt << "INSERT INTO #{repo.config[:storage]} ("
        stmt << fields.map { |name, opts| "#{name}" unless name == :id }.compact.join(",")
        stmt << ") VALUES ("
        stmt << fields.map { |name, opts| "?" unless name == :id }.compact.join(",")
        stmt << ");"
      end
      ret = with_db { |db| db.exec statement, args }
      return ret.last_insert_id
    end

    def with_db
      yield DB.open @uri
    end

    def sqlite_type_for(v)
      case v
      when String.class                ; "text"
      when Int32.class, Int64.class    ; "int"
      when Float32.class, Float64.class; "float"
      when Time.class                  ; "text"
      else
        raise "not implemented for #{v}"
      end
    end

    def commands : Array(Symbol)
      [:create, :save, :get]
    end
  end
end
