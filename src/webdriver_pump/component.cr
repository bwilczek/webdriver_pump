require "selenium"

require "./wait"
require "./exceptions"

module WebdriverPump
  class Component
    include LocateElement

    getter :session

    macro form_element(name, params)
      def {{name.id}}=(val)
        {{params[:class]}}.new(root, {{params[:locator]}}).value = val
      end

      def {{name.id}}
        {{params[:class]}}.new(root, {{params[:locator]}}).value
      end
    end

    macro element(name, params)
      def {{name.id}}(*args)
        element = locate_element({{params[:locator]}})

        {% if params[:class] %}
          element = {{params[:class]}}.new(session, element)
        {% end %}

        {% if params[:action] %}
          element.{{params[:action].id}}(*args)
        {% else %}
          element
        {% end %}
      end
    end

    macro elements(name, params)
      def {{name.id}}(*args)
        elements = locate_elements({{params[:locator]}})

        {% if params[:class] %}
          elements = elements.map do |element|
            {{params[:class]}}.new(session, element)
          end
        {% end %}

        {% if params[:collection_class] %}
          {{params[:collection_class]}}.new(elements)
        {% else %}
          elements
        {% end %}
      end
    end

    macro fill_form(name, params)
      def {{name.id}}(data : NamedTuple)
        {% for field in params[:fields] %}
          self.{{field.id}} = data[{{field}}]
        {% end %}
        {% if params[:submit] %}
          {{params[:submit].id}}
        {% end %}
      end
    end

    macro form_data(name, params)
      def {{name.id}} : NamedTuple
        {
        {% for field in params[:fields] %}
          {{field.id}}: self.{{field.id}},
        {% end %}
        }
      end
    end

    def initialize(@session : Selenium::Session, @root : Selenium::WebElement)
    end

    def wait
      WebdriverPump::Wait
    end
  end
end
