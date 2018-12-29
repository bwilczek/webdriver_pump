require "./spec_helper"

session = WebdriverSessionHelper.session

class FormPage < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}//form.html"
  element_setter :name, { type: :text_field, locator: {id: "name"} }
  element_getter :name, { type: :text_field, locator: {id: "name"} }
  element_accessor :description, { type: :text_area, locator: {id: "description"} }
end

##############################################

describe WebdriverPump do
  it "form elements: text field" do
    FormPage.new(session).open do |p|
      p.name = "Kasia"
      p.name.should eq "Kasia"
    end
  end

  it "form elements: text area" do
    FormPage.new(session).open do |p|
      p.description = "Kasia has a cat"
      p.description.should eq "Kasia has a cat"
    end
  end
end
