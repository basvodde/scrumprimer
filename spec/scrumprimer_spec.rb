# encoding: utf-8

require './scrumprimer'
require 'capybara'
require 'capybara/dsl'

set :environment, :test

describe "Scrum Primer Basic Specs" do

  include Capybara::DSL

  before do
    Capybara.app = ScrumPrimerApp.new
  end

  it "is able to get to the basic English page at the root" do
    visit '/'
    page.all(:xpath, "id('home')")[0]["class"].should include("active")
    page.all(:xpath, "id('mainTabs')/li[@id='navHome']")[0]["class"].should include("active")
    page.should have_content "Current Version"
  end

  it "can click to the translation tab and the url changed" do
    visit '/'
    click_link "Translations"

    page.should have_content "PDF versions of the Overview picture"
    page.all(:xpath, "id('mainTabs')/li[@id='navTranslations']")[0]["class"].should include("active")
    current_path.should== "/translations"
  end

  it "can click on the overview tab" do
    visit '/'
    click_link "Overview Picture"
    page.should have_content "PDF versions of the Overview picture"
    current_path.should== "/overview"
  end

  it "can click on the anime tab" do
    visit '/'
    click_link "Anime Overview"
    page.should have_content "High-resolution versions of the overview:"
    current_path.should== "/anime"
  end

  it "can click on the about tab" do
    visit '/'
    click_link "About"
    page.should have_content "Scrum Primer Creation"
    current_path.should== "/about"
  end

  it "can click on the contact tab" do
    visit '/'
    click_link "Contact"
    page.should have_content "Feedback"
    current_path.should== "/contact"
  end

  it "has all pages with links to all available locales in the i18n directory" do
    visit '/about'
    locales = []
    Dir.glob("./i18n/*.yml") {|file| locales << File.basename(file, ".*")}

    locales.each { |locale|
      page.find("a[href='/#{locale}/']").should be_true
    }
  end

  it "should go to the 404 page when going to an URL that doesn't exist" do
    visit '/doesntexist'
    page.should have_content "404"
    page.status_code.should == 404
  end

  it "should have different title pages for each page" do
    visit '/'
    page.should have_title "Scrum Primer - Short Introduction"
    visit '/translations'
    page.should have_title "Scrum Primer - Translations"
  end

  it 'should have a sitemap.xml file' do
    visit '/sitemap.xml'
    page.status_code.should == 200
    page.should have_content 'http://scrumprimer.org/'
  end
end
