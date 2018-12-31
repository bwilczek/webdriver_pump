require "./spec_helper"

session = WebdriverSessionHelper.session

class FormPage < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}//form.html"
  element_setter :name, { type: :text_field, locator: {id: "name"} }
  element_getter :name, { type: :text_field, locator: {id: "name"} }

  element_accessor :description, { type: :text_area, locator: {id: "description"} }

  element_setter :gender, { type: :radio_group, locator: {name: "gender"} }
  element_getter :gender, { type: :radio_group, locator: {name: "gender"} }
  element_setter :predicate, { type: :radio_group, locator: {name: "predicate"} }
  element_getter :predicate, { type: :radio_group, locator: {name: "predicate"} }

  element_setter :confirmation, { type: :checkbox, locator: {name: "confirmation"} }
  element_getter :confirmation, { type: :checkbox, locator: {name: "confirmation"} }

  element_getter :unsupported_getter, { type: :no_such_type, locator: {id: "name"} }
  element_setter :unsupported_setter, { type: :no_such_type, locator: {id: "name"} }

  fill_form :submit_data, { submit: :generate, fields: [:name, :description, :gender, :predicate] }
  form_data :read_data, { fields: [:name, :description, :gender, :predicate] }

  def generate
    root.find_element(:id, "generate").click
  end
end

##############################################

describe WebdriverPump do
  it "form elements: text_field" do
    FormPage.new(session).open do |p|
      p.name = "Kasia"
      p.name.should eq "Kasia"
    end
  end

  it "form elements: text_area" do
    FormPage.new(session).open do |p|
      p.description = "Kasia has a cat"
      p.description.should eq "Kasia has a cat"
    end
  end

  it "form elements: checkbox" do
    FormPage.new(session).open do |p|
      p.confirmation = true
      p.confirmation.should eq true
      p.confirmation = false
      p.confirmation.should eq false
    end
  end

  it "form elements: radio_group" do
    FormPage.new(session).open do |p|
      p.gender = "Female"
      p.predicate = "No"
      p.gender.should eq "Female"
      p.predicate.should eq "No"
    end
  end

  it "form elements: fill_form/form_data" do
    FormPage.new(session).open do |p|
      p.submit_data({
        gender: "Female",
        predicate: "No",
        name: "Kasia",
        description: "Kasia has a cat"
      })
      data = p.read_data
      data[:gender].should eq "Female"
      data[:predicate].should eq "No"
      data[:name].should eq "Kasia"
      data[:description].should eq "Kasia has a cat"
    end
  end

  it "form elements: getter raises exception for unsupported element type" do
    FormPage.new(session).open do |p|
      expect_raises(WebdriverPump::UnsupportedFormElement) do
        p.unsupported_getter
      end
    end
  end

  it "form elements: setter raises exception for unsupported element type" do
    FormPage.new(session).open do |p|
      expect_raises(WebdriverPump::UnsupportedFormElement) do
        p.unsupported_setter = "asd"
      end
    end
  end
end
