require "./spec_helper"

session = WebdriverSessionHelper.session

class ParametrizedPage < WebdriverPump::Page
  url "https://{user}.github.io/{repo}/query.html"
end

describe WebdriverPump do
  it "parameterize page URL" do
    params = {user: "bwilczek", repo: "watir_pump_tutorial"}
    query = {name: "Bob", surname: "Smith"}
    ParametrizedPage.new(session).open(params: params, query: query) do |p|
      session.url.should eq "https://bwilczek.github.io/watir_pump_tutorial/query.html?name=Bob&surname=Smith"
    end
  end
end
