require "selenium"

require "./wait"

module WebdriverPump
  class Component
    getter :root
    getter :session

    macro element(name, params)
      def {{name.id}}(*args)
        {% if params[:locator].class_name == "ProcLiteral" %}
          element = dynamically_locate_element({{params[:locator]}})
        {% elsif params[:locator].class_name == "NamedTupleLiteral" %}
          by = :{{params[:locator].keys.first.id}}
          selector = "{{params[:locator].values.first.id}}"
          element = locate_element(by: by, selector: selector)
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

    macro elements(name, params)
      def {{name.id}}(*args)
        {% if params[:locator].class_name == "ProcLiteral" %}
          elements = dynamically_locate_elements({{params[:locator]}})
        {% elsif params[:locator].class_name == "NamedTupleLiteral" %}
          by = :{{params[:locator].keys.first.id}}
          selector = "{{params[:locator].values.first.id}}"
          elements = locate_elements(by: by, selector: selector)
        {% else %}
          raise "element macro: Unsupported locator"
        {% end %}

        {% if params[:class] %}
          elements.map! do |element|
            {{params[:class]}}.new(session, element)
          end
        {% end %}
        elements
      end
    end

    def initialize(@session : Selenium::Session, @root : Selenium::WebElement)
    end

    def locate_element(*, by, selector)
      root.find_element(by, selector)
    end

    def locate_elements(*, by, selector)
      root.find_elements(by, selector)
    end

    def dynamically_locate_element(expression)
      # TODO: check if the returned value is an element
      expression.call
    end

    def dynamically_locate_elements(expression)
      # TODO: check if the returned value is an element collection
      expression.call
    end

    def wait
      WebdriverPump::Wait
    end
  end
end
