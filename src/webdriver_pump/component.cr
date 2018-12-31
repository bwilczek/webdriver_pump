require "selenium"

require "./wait"

module WebdriverPump
  class Component
    getter :root
    getter :session

    # TODO: DRY up
    macro element_accessor(name, params)
      def {{name.id}}
        get_element_value({{params[:locator]}}, {{params[:type]}})
      end

      def {{name.id}}=(val)
        set_element_value({{params[:locator]}}, {{params[:type]}}, val)
      end
    end

    macro element_getter(name, params)
      def {{name.id}}
        get_element_value({{params[:locator]}}, {{params[:type]}})
      end
    end

    macro element_setter(name, params)
      def {{name.id}}=(val)
        set_element_value({{params[:locator]}}, {{params[:type]}}, val)
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

    # GETTERS #############################

    def get_element_value(locator, type)
      case type
      when :text_field, :text_area
        get_text_value(locator)
      when :radio_group
        get_radio_group_value(locator)
      when :checkbox
        get_checkbox(locator)
      else
        raise UnsupportedFormElement.new(type)
      end
    end

    def get_text_value(locator)
      element = locate_element(locator)
      element.attribute("value")
    end

    def get_radio_group_value(locator)
      elements = locate_elements(locator)
      elements.each do |el|
        next unless el.selected?
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = root.find_element(:xpath, ".//label[@for='#{id}']")
        end
        return label.text
      end
    end

    def get_checkbox(locator)
      locate_element(locator).selected?
    end

    # SETTERS #############################

    def set_element_value(locator, type, value : String|Bool)
      case type
      when :text_field, :text_area
        set_text_value(locator, value.to_s)
      when :radio_group
        set_radio_group_value(locator, value.to_s)
      when :checkbox
        set_checkbox(locator, !!value)
      else
        raise UnsupportedFormElement.new(type)
      end
    end

    def set_text_value(locator, value)
      element = locate_element(locator)
      element.send_keys(value)
    end

    def set_radio_group_value(locator, value)
      elements = locate_elements(locator)
      elements.each do |el|
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = root.find_element(:xpath, ".//label[@for='#{id}']")
        end
        if label.text == value
          label.click
          return
        end
      end
    end

    def set_checkbox(locator, value)
      element = locate_element(locator)
      element.click if element.selected? != value
    end
  end
end
