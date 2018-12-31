require "./spec_helper"

session = WebdriverSessionHelper.session

class FormPage < WebdriverPump::Page
  url "#{WebdriverSessionHelper.base_url}/form.html"
  element_setter :name, { type: :text_field, locator: {id: "name"} }
  element_getter :name, { type: :text_field, locator: {id: "name"} }

  element_setter :description, { type: :text_area, locator: {id: "description"} }
  element_getter :description, { type: :text_area, locator: {id: "description"} }

  element_setter :gender, { type: :radio_group, locator: {name: "gender"} }
  element_getter :gender, { type: :radio_group, locator: {name: "gender"} }
  element_setter :predicate, { type: :radio_group, locator: {name: "predicate"} }
  element_getter :predicate, { type: :radio_group, locator: {name: "predicate"} }

  element_setter :hobbies, { type: :checkbox_group, locator: {name: "hobbies[]"} }
  element_getter :hobbies, { type: :checkbox_group, locator: {name: "hobbies[]"} }
  element_setter :continents, { type: :checkbox_group, locator: {name: "continents[]"} }
  element_getter :continents, { type: :checkbox_group, locator: {name: "continents[]"} }

  element_setter :confirmation, { type: :checkbox, locator: {name: "confirmation"} }
  element_getter :confirmation, { type: :checkbox, locator: {name: "confirmation"} }

  element_setter :car, { type: :select_list, locator: {name: "car"} }
  element_getter :car, { type: :select_list, locator: {name: "car"} }

  element_setter :ingredients, { type: :multi_select_list, locator: {name: "ingredients[]"} }
  element_getter :ingredients, { type: :multi_select_list, locator: {name: "ingredients[]"} }

  element_getter :unsupported_getter, { type: :no_such_type, locator: {id: "name"} }
  element_setter :unsupported_setter, { type: :no_such_type, locator: {id: "name"} }

  fill_form :submit_data, { submit: :generate, fields: [:name, :description, :gender, :predicate] }
  form_data :read_data, { fields: [:name, :description, :gender, :predicate] }

  fill_form :submit_for_summary, { submit: :generate, fields: [:name, :gender, :ingredients] }
  form_data :read_summary, { fields: [:summary_name, :summary_gender, :summary_ingredients]}

  element :summary_name, { locator: {id: "res_name"}, action: :text }
  element :summary_gender, { locator: {id: "res_gender"}, action: :text }

  def summary_ingredients
    root.find_elements(:xpath, ".//ul[@id='res_ingredients']/li").map { |i| i.text }
  end

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

  it "form elements: checkbox_group" do
    FormPage.new(session).open do |p|
      p.hobbies = ["Knitting", "Dancing"]
      p.hobbies.sort.should eq ["Dancing", "Knitting"]
      p.hobbies = ["Gardening", "Knitting"]
      p.hobbies.sort.should eq ["Gardening", "Knitting"]
      p.continents = ["Asia", "North America", "Australia"]
      p.continents.sort.should eq ["Asia", "Australia", "North America"]
    end
  end

  it "form elements: select_list" do
    FormPage.new(session).open do |p|
      p.car = "Opel"
      p.car.should eq "Opel"
      p.car = "BMW"
      p.car.should eq "BMW"
    end
  end

  it "form elements: multi_select_list" do
    FormPage.new(session).open do |p|
      p.ingredients = ["Eggplant", "Asparagus"]
      p.ingredients.sort.should eq ["Asparagus", "Eggplant"]
      p.ingredients = ["Eggplant", "Onion"]
      p.ingredients.sort.should eq ["Eggplant", "Onion"]
    end
  end

  it "form helpers: fill_form/form_data(form controls)" do
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

  it "form helpers: fill_form/form_data(summary elements)" do
    FormPage.new(session).open do |p|
      p.submit_for_summary({
        name: "Kasia",
        gender: "Female",
        ingredients: ["Eggplant", "Asparagus"]
      })
      data = p.read_summary
      data[:summary_name].should eq "Kasia"
      data[:summary_gender].should eq "Female"
      data[:summary_ingredients].sort.should eq ["Asparagus", "Eggplant"]
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
