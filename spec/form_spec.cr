require "./spec_helper"

session = WebdriverSessionHelper.session

class FormPage < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}//form.html"
  element_setter :name, { locator: {id: "name"} }
  element_getter :name, { locator: {id: "name"} }
end

##############################################

describe WebdriverPump do
  it "form elements: text input" do
    FormPage.new(session).open do |p|
      p.name = "Kasia"
      p.name.should eq "Kasia"
    end
  end
end
