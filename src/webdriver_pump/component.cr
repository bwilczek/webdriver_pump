require "selenium"

require "./wait"

module WebdriverPump
  class Component
    getter :root
    getter :session

    FORM_ACCESSRS = {
      text_field: {get: "attribute(\"value\")", set: "send_keys(val)"},
      text_area: {get: "attribute(\"value\")", set: "send_keys(val)"},
    }

    # TODO: DRY up
    macro element_accessor(name, params)
      def {{name.id}}
        element = locate_element({{params[:locator]}})
        element.{{FORM_ACCESSRS[params[:type]][:get].id}}
      end

      def {{name.id}}=(val)
        element = locate_element({{params[:locator]}})
        element.{{FORM_ACCESSRS[params[:type]][:set].id}}
      end
    end

    macro element_getter(name, params)
      def {{name.id}}
        element = locate_element({{params[:locator]}})
        element.{{FORM_ACCESSRS[params[:type]][:get].id}}
      end
    end

    macro element_setter(name, params)
      def {{name.id}}=(val)
        element = locate_element({{params[:locator]}})
        element.{{FORM_ACCESSRS[params[:type]][:set].id}}
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

    def initialize(@session : Selenium::Session, @root : Selenium::WebElement)
    end

    def locate_element(locator)
      if locator.is_a?(Proc)
        # TODO: validate returned type
        return locator.call
      elsif locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_element(by, selector)
      else
        raise "element macro: Unsupported locator"
      end
    end

    def locate_elements(locator)
      if locator.is_a?(Proc)
        # TODO: validate returned type
        return locator.call
      elsif locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_elements(by, selector)
      else
        raise "element macro: Unsupported locator"
      end
    end

    def wait
      WebdriverPump::Wait
    end
  end
end
