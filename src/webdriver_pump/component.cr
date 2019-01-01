require "selenium"

require "./wait"
require "./exceptions"

module WebdriverPump
  class Component
    getter :root
    getter :session

    macro element_getter(name, params)
      def {{name.id}}
        {% if params[:type] == :text_field %}
          get_text_value({{params[:locator]}})
        {% elsif params[:type] == :text_area %}
          get_text_value({{params[:locator]}})
        {% elsif params[:type] == :radio_group %}
          get_radio_group_value({{params[:locator]}})
        {% elsif params[:type] == :checkbox %}
          get_checkbox_value({{params[:locator]}})
        {% elsif params[:type] == :checkbox_group %}
          get_checkbox_group_values({{params[:locator]}})
        {% elsif params[:type] == :select_list %}
          get_select_list_value({{params[:locator]}})
        {% elsif params[:type] == :multi_select_list %}
          get_multi_select_list_values({{params[:locator]}})
        {% else %}
          raise WebdriverPump::UnsupportedFormElement.new({{params[:type]}})
        {% end %}
      end
    end

    macro element_setter(name, params)
      def {{name.id}}=(val)
        {% if params[:type] == :text_field %}
          set_text_value({{params[:locator]}}, val)
        {% elsif params[:type] == :text_area %}
          set_text_value({{params[:locator]}}, val)
        {% elsif params[:type] == :radio_group %}
          set_radio_group_value({{params[:locator]}}, val)
        {% elsif params[:type] == :checkbox %}
          set_checkbox_value({{params[:locator]}}, val)
        {% elsif params[:type] == :checkbox_group %}
          set_checkbox_group_values({{params[:locator]}}, val)
        {% elsif params[:type] == :select_list %}
          set_select_list_value({{params[:locator]}}, val)
        {% elsif params[:type] == :multi_select_list %}
          set_multi_select_list_values({{params[:locator]}}, val)
        {% else %}
          raise WebdriverPump::UnsupportedFormElement.new({{params[:type]}})
        {% end %}
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
        ret = locator.call
        raise UnexpectedElementType.new(ret.class.name) unless ret.is_a?(Selenium::WebElement)
        return ret
      elsif locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_element(by, selector)
      else
        raise UnsupportedLocator.new(locator.class.name)
      end
    end

    def locate_elements(locator)
      if locator.is_a?(Proc)
        ret = locator.call
        raise UnexpectedElementType.new(ret.class.name) unless ret.is_a?(Array(Selenium::WebElement))
        return ret
      elsif locator.is_a?(NamedTuple)
        by = locator.keys.first
        selector = locator.values.first
        return root.find_elements(by, selector)
      else
        raise UnsupportedLocator.new(locator.class.name)
      end
    end

    def wait
      WebdriverPump::Wait
    end

    # GETTERS #############################

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

    def get_checkbox_value(locator)
      locate_element(locator).selected?
    end

    def get_checkbox_group_values(locator)
      elements = locate_elements(locator)
      ret = Array(String).new
      elements.each do |el|
        next unless el.selected?
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = root.find_element(:xpath, ".//label[@for='#{id}']")
        end
        ret << label.text
      end
      ret
    end

    def get_select_list_value(locator)
      element = locate_element(locator)
      element.find_elements(:xpath, ".//option").each do |option|
        return option.text if option.selected?
      end
    end

    def get_multi_select_list_values(locator)
      element = locate_element(locator)
      ret = Array(String).new
      element.find_elements(:xpath, ".//option").each do |option|
        ret << option.text if option.selected?
      end
      ret
    end

    # SETTERS #############################

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

    def set_checkbox_value(locator, value)
      element = locate_element(locator)
      element.click if element.selected? != value
    end

    def set_checkbox_group_values(locator, values : Array(String))
      elements = locate_elements(locator)
      elements.each do |el|
        begin
          label = el.find_element(:xpath, "./parent::label")
        rescue
          id = el.attribute("id")
          label = root.find_element(:xpath, ".//label[@for='#{id}']")
        end
        label.click if el.selected?
        label.click if values.includes?(label.text)
      end
    end

    def set_select_list_value(locator, value)
      element = locate_element(locator)
      element.find_elements(:xpath, ".//option").each do |option|
        if option.text == value
          option.click
          return
        end
      end
    end

    def set_multi_select_list_values(locator, values)
      element = locate_element(locator)
      element.find_elements(:xpath, ".//option").each do |option|
        option.click if option.selected?
        if values.includes?(option.text)
          option.click
        end
      end
    end
  end
end
