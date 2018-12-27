class BaseElement
  def find_element(by, what)
    Element1.new
  end

  def click
    puts "element clicked"
  end

  def debug
    "base debug"
  end
end

class Session < BaseElement
  def debug
    "session debug"
  end
end

class Element1 < BaseElement
  def debug
    "element1 debug"
  end
end

class Element2 < BaseElement
  def debug
    "element2 debug"
  end
end

class Component < BaseElement
  getter :root
  getter :session

  macro element(name, params)
    def {{name.id}}(*args)
      {% if params[:locator].class_name == "ProcLiteral" %}
        element = dynamically_locate_element({{params[:locator]}})
      {% elsif params[:locator].class_name == "NamedTupleLiteral" %}
        by = :{{params[:locator].keys.first.id}}
        what = "{{params[:locator].values.first.id}}"
        element = locate_element(by: by, what: what)
      {% else %}
        raise "element macro: Unsupported locator"
      {% end %}

      ret = element

      {% if params[:class] %}
        ret = {{params[:class]}}.new(session, element)
      {% end %}

      {% if params[:action] %}
        ret.{{params[:action].id}}(*args)
      {% else %}
        ret
      {% end %}
    end
  end

  def initialize(@session : Session, @root : BaseElement)
  end

  def locate_element(*, by, what)
    root.find_element(by, what)
  end

  def dynamically_locate_element(expression)
    # TODO: check if the returned value is an element
    expression.call
  end
end

class Page < Component
  macro uri(uri)
    def uri
      {{uri}}
    end
  end

  def initialize(@session : Session)
    @root = @session
  end

  def open(&blk : self -> _)
    puts "opening page... #{uri}"
    use(&blk)
  end

  def use
    # TODO: check if page loaded
    yield self
  end
end

class Title < Component
  def debug
    "debug title"
  end

  def debug_msg(msg)
    msg
  end
end

class HomePage < Page
  uri "/home"
  element :title_raw, { locator: { xpath: "//h1" } }
  element :title, { locator: { xpath: "//h1" }, class: Title }
  element :title_action, { locator: { xpath: "//h1" }, class: Title, action: :debug }
  element :title_action_param, {
    locator: { xpath: "//h1" },
    class: Title,
    action: :debug_msg
  }
  element :header, { locator: -> { root.debug + ' ' + session.debug } }
end

session = Session.new

HomePage.new(session).open do |p|
  puts p.title_raw.debug
  puts p.title.debug
  puts p.title_action_param("kasia")
  puts p.title_action
  puts p.header
end
