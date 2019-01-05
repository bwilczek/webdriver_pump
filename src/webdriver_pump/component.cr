require "selenium"

require "./wait"
require "./exceptions"

module WebdriverPump
  class Component
    getter :root
    getter :session

    macro elements_setter(name, params)
      def {{name.id}}=(val)
        elements = locate_elements({{params[:locator]}})
        {{params[:class]}}.new(elements).value = val
      end
    end

    macro elements_getter(name, params)
      def {{name.id}}
        elements = locate_elements({{params[:locator]}})
        {{params[:class]}}.new(elements).value
      end
    end

    macro element_setter(name, params)
      def {{name.id}}=(val)
        element = locate_element({{params[:locator]}})
        {{params[:class]}}.new(element).value = val
      end
    end

    macro element_getter(name, params)
      def {{name.id}}
        element = locate_element({{params[:locator]}})
        {{params[:class]}}.new(element).value
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

    def locate_element(locator : ElementLocator)
      if locator.is_a?(Proc)
        return locator.call
      else # locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_element(by, selector)
      end
    end

    def locate_elements(locator : ElementsLocator)
      if locator.is_a?(Proc)
        locator.call
      else # locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_elements(by, selector)
      end
    end

    def wait
      WebdriverPump::Wait
    end
  end
end
