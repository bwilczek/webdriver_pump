require "./spec_helper"

include WebdriverPump

session = WebdriverSessionHelper.session

class FormPage < Page
  url "#{WebdriverSessionHelper.base_url}/form.html"

  form_element :name, {class: TextField, locator: {css: "#name"}}
  form_element :description, {class: TextArea, locator: {css: "#description"}}

  form_element :gender, {class: RadioGroup, locator: {css: "[name=gender]"}}
  form_element :predicate, {class: RadioGroup, locator: {css: "[name=predicate]"}}

  # TODO: replace with name: hobbies[] as soon as it's added to selenium.cr
  form_element :hobbies, {class: CheckboxGroup, locator: {xpath: ".//input[@name='hobbies[]']"}}
  form_element :continents, {class: CheckboxGroup, locator: {xpath: ".//input[@name='continents[]']"}}

  form_element :confirmation, {class: Checkbox, locator: {css: "[name=confirmation]"}}

  form_element :car, {class: SelectList, locator: {css: "[name=car]"}}

  form_element :ingredients, {class: MultiSelectList, locator: {xpath: ".//select[@name='ingredients[]']"}}

  fill_form :submit_data, {submit: :generate, fields: [:name, :description, :gender, :predicate]}
  form_data :read_data, {fields: [:name, :description, :gender, :predicate]}

  fill_form :submit_for_summary, {submit: :generate, fields: [:name, :gender, :ingredients]}
  form_data :read_summary, {fields: [:summary_name, :summary_gender, :summary_ingredients]}

  element :summary_name, {locator: {css: "#res_name"}, action: :text}
  element :summary_gender, {locator: {css: "#res_gender"}, action: :text}

  def summary_ingredients
    root.find_child_elements(:xpath, ".//ul[@id='res_ingredients']/li").map { |i| i.text }
  end

  def generate
    root.find_child_element(:css, "#generate").click
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
        gender:      "Female",
        predicate:   "No",
        name:        "Kasia",
        description: "Kasia has a cat",
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
        name:        "Kasia",
        gender:      "Female",
        ingredients: ["Eggplant", "Asparagus"],
      })
      data = p.read_summary
      data[:summary_name].should eq "Kasia"
      data[:summary_gender].should eq "Female"
      data[:summary_ingredients].sort.should eq ["Asparagus", "Eggplant"]
    end
  end
end
