

url = ENV['VAMP_URL']
driver_name = :phantomjs
driver_name = ENV['SELENIUM_DRIVER'].to_sym if ENV['SELENIUM_DRIVER']
do_screenshots = false
do_screenshots = true if ENV['DO_SCREENSHOTS'] == "true"

c = 0

exit 1 if url == nil

require 'selenium-webdriver'
driver = Selenium::WebDriver.for driver_name
driver.manage.window.size = Selenium::WebDriver::Dimension.new(1480, 900)

puts "Using URL: " + url + "\n"
driver.navigate.to url
sleep 5

if do_screenshots
  driver.save_screenshot("screen_" + c.to_s + ".png")
  c = c + 1
end



RSpec.describe "click on `Docker Compose` button in blueprints"  do
  it "- should display modal dialog" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:tag_name, "li")
      .select { |i| i.attribute("class") != 'has-sub-menu' }
      .select { |i| i.attribute("class") != 'sub-menu-item' }
      .select { |i| i.text.downcase == 'blueprints' }
      .each { |i|
        i.find_element(:tag_name, "a").click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end
        button = driver
                  .find_elements(:xpath, "//div[@class='row content-header']//button")
                  .select { |j| j.text == 'Docker Compose' }
                  .first

        button.click()
        sleep 1
        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end
        expect(driver.find_element(:xpath, "//div[@class='modal-content']").displayed?).to eq(true)
      }
  end
end

RSpec.describe "click on `Cancel` button in blueprints modal dialog"  do
  it "- should close modal dialog" do
    button = driver
              .find_elements(:xpath, "//div[@class='modal-content']//button")
              .select { |j| j.text == 'Cancel' }
              .first

    button.click()

    if do_screenshots
      driver.save_screenshot("screen_" + c.to_s + ".png")
      c = c + 1
    end

    button = driver
              .find_elements(:xpath, "//div[@class='row content-header']//button")
              .select { |j| j.text == 'Add' }
              .first

    if do_screenshots
      driver.save_screenshot("screen_" + c.to_s + ".png")
      c = c + 1
    end

    expect(button.displayed?).to eq(true)
  end
end


RSpec.describe "basic checks on top menu items"  do
  it "

  - header text should be the equal to a button text
  - editor shoud be displayed
  - editor should be closed
      " do
    driver.navigate.to url
    sleep 1
    if do_screenshots
      driver.save_screenshot("screen_" + c.to_s + ".png")
      c = c + 1
    end

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:tag_name, "li")
      .select{ |i| i.attribute("class") != 'has-sub-menu' }
      .select{ |i| i.attribute("class") != 'sub-menu-item' }
      .each { |i|
        i.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:css, "div.header-content").text.downcase).to eq(i.text.downcase)
        expect(driver.current_url).to eq(url.downcase + i.attribute("href"))

        button = driver
                  .find_elements(:xpath, "//div[@class='row content-header']//button")
                  .select { |j| j.text == 'Add' }
                  .first

        next_url = driver.current_url + "/" + button.text.downcase
        button.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:xpath, "//div[@id='editor']").displayed?).to eq(true)
        expect(driver.current_url).to eq(next_url)

        button = driver
                  .find_elements(:xpath, "//div[@class='editor-buttons clearfix']//button")
                  .select { |j| j.text == 'Cancel' }
                  .first

        next_url = driver.current_url.split("/")[0..-2].join("/")
        button.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        button = driver
                  .find_elements(:xpath, "//div[@class='row content-header']//button")
                  .select { |j| j.text == 'Add' }
                  .first

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(button.displayed?).to eq(true)
        expect(driver.current_url).to eq(next_url)
      }
  end
end


RSpec.describe "open sub menu"  do
  it "- should display sub menu" do
    driver.navigate.to url
    sleep 1

    if do_screenshots
      driver.save_screenshot("screen_" + c.to_s + ".png")
      c = c + 1
    end

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='has-sub-menu']")
      .select{ |i| i.attribute("href") == nil }
      .each { |i|
        i.find_element(:tag_name, "a").click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:css, "ul.sub-menu").displayed?).to eq(true)
      }
  end
end


RSpec.describe "basic checks on sub menu items"  do
  it "- header text should be the equal to a button text" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .each { |i|
        i.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:css, "div.header-content").text.downcase).to eq(i.text.downcase)
        expect(driver.current_url).to eq(url.downcase + i.attribute("href"))
      }
  end
end


RSpec.describe "test each tab in backend configuration"  do
  it "- tab content should be displayed" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .select { |i| i.text.downcase == 'backend configuration' }
      .each { |i|
        i.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        driver
          .find_elements(:xpath, "//ul[@class='nav nav-tabs']//li")
          .each { |j|
            j.click()
            sleep 1

            if do_screenshots
              driver.save_screenshot("screen_" + c.to_s + ".png")
              c = c + 1
            end

            expect(driver.find_element(:css, "div.tab-content").displayed?).to eq(true)
          }
      }
  end
end


RSpec.describe "test each tab in vga configuration"  do
  it "- tab content should be displayed" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .select { |i| i.text.downcase == 'vga configuration' }
      .each { |i|
        i.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        driver
          .find_elements(:xpath, "//ul[@class='nav nav-tabs']//li")
          .each { |j|
            j.click()

            if do_screenshots
              driver.save_screenshot("screen_" + c.to_s + ".png")
              c = c + 1
            end

            expect(driver.find_element(:css, "div.tab-content").displayed?).to eq(true)
          }
      }
  end
end


RSpec.describe "test editor in extended info"  do
  it "- editor should be displayed" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .select { |i| i.text.downcase == 'extended info' }
      .each { |i|
        i.click()
        sleep 1

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:xpath, "//div[@id='editor']").displayed?).to eq(true)
      }
  end
end


RSpec.describe "test panels in log"  do
  it "- panels should be displayed" do
    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .select { |i| i.text.downcase == 'log' }
      .each { |i|
        i.click()

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:xpath, "//div[@class='panel-heading']").displayed?).to eq(true)
        expect(driver.find_element(:xpath, "//div[@class='panel-body']").displayed?).to eq(true)
      }
  end
end
