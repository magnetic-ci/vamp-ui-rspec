require 'selenium-webdriver'

url = ENV['VAMP_URL']
driver_name = :chrome
driver_options = Selenium::WebDriver::Chrome::Options.new
driver_options.add_argument('--no-sandbox')
do_screenshots = false
do_screenshots = true if ENV['DO_SCREENSHOTS'] == "true"

exit 1 if url == nil
puts "Using URL: " + url + "\n"
c = 0


RSpec.describe "check Docker Compose in blueprints"  do
  it "
  - should display modal dialog
  - should close modal dialod
  " do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

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
    driver.quit
  end
end


RSpec.describe "basic checks on top menu items"  do
  it "
  - header text should be the equal to a button text
  - editor should be displayed
  - editor should be closed
    " do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:tag_name, "li")
      .select { |i| i.attribute("class") != 'has-sub-menu' }
      .select { |i| i.attribute("class") != 'sub-menu-item' }
      .select { |i| i.text.downcase != 'collapse menu' }
      .each { |i|
        i.click()
        wait.until { driver.find_element(:css, "div.header-content") }

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
        wait.until { driver.find_elements(:xpath, "//div[@class='editor-buttons clearfix']//button") }

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:xpath, "//div[@id='editor']").displayed?).to eq(true)
        expect(driver.current_url).to eq(next_url)

        button = driver
                  .find_elements(:xpath, "//div[@class='editor-buttons clearfix']//button")
                  .first

        next_url = driver.current_url.split("/")[0..-2].join("/")
        button.click()
        wait.until { driver.find_elements(:xpath, "//div[@class='row content-header']//button") }

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

      driver.quit
  end
end


RSpec.describe "basic checks on sub menu items"  do
  it "- header text should be the equal to a button text" do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_elements(:xpath, "//a[@class='btn-link collapse-btn']")
      .first
      .click()

    wait.until { driver.find_elements(:xpath, "//span[@class='icon-label hidden-xs']") }

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='has-sub-menu']")
      .select{ |i| i.attribute("href") == nil }
      .each { |i|
        i.find_element(:tag_name, "a").click()
        wait.until { driver.find_elements(:xpath, "//a[@class='capitalize']") }

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:css, "ul.sub-menu").displayed?).to eq(true)
        break
      }

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .each { |i|
        i.click()
        wait.until { driver.find_elements(:xpath, "//div[@class='container-fluid main-view']") }

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        expect(driver.find_element(:css, "div.header-content").text.downcase).to eq(i.text.downcase)
        expect(driver.current_url).to eq(url.downcase + i.attribute("href"))
      }

      driver.quit
  end
end


RSpec.describe "test each tab in backend configuration"  do
  it "- tab content should be displayed" do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_elements(:xpath, "//a[@class='btn-link collapse-btn']")
      .first
      .click()

    wait.until { driver.find_elements(:xpath, "//span[@class='icon-label hidden-xs']") }

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

    driver
      .find_element(:css, "ul.sidebar-nav")
      .find_elements(:xpath, "//li[@class='sub-menu-item']")
      .select { |i| i.text.downcase == 'backend configuration' }
      .each { |i|
        i.click()
        wait.until { driver.find_element(:css, "div.header-content") }

        if do_screenshots
          driver.save_screenshot("screen_" + c.to_s + ".png")
          c = c + 1
        end

        driver
          .find_elements(:xpath, "//ul[@class='nav nav-tabs']//li")
          .each { |j|
            j.click()
            wait.until { driver.find_elements(:xpath, "//dev[@class='nav nav-tabs']//li[@class='active']") }

            if do_screenshots
              driver.save_screenshot("screen_" + c.to_s + ".png")
              c = c + 1
            end

            expect(driver.find_element(:css, "div.tab-content").displayed?).to eq(true)
          }
      }

    driver.quit
  end
end


RSpec.describe "test each tab in vga configuration"  do
  it "- tab content should be displayed" do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_elements(:xpath, "//a[@class='btn-link collapse-btn']")
      .first
      .click()

    wait.until { driver.find_elements(:xpath, "//span[@class='icon-label hidden-xs']") }

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
            wait.until { driver.find_elements(:xpath, "//dev[@class='nav nav-tabs']//li[@class='active']") }

            if do_screenshots
              driver.save_screenshot("screen_" + c.to_s + ".png")
              c = c + 1
            end

            expect(driver.find_element(:css, "div.tab-content").displayed?).to eq(true)
          }
      }

    driver.quit
  end
end


RSpec.describe "test editor in extended info"  do
  it "- editor should be displayed" do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_elements(:xpath, "//a[@class='btn-link collapse-btn']")
      .first
      .click()

    wait.until { driver.find_elements(:xpath, "//span[@class='icon-label hidden-xs']") }

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

    driver.quit
  end
end


RSpec.describe "test panels in log"  do
  it "- panels should be displayed" do
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    driver = Selenium::WebDriver.for driver_name, options: driver_options
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1920, 1080)
    driver.navigate.to url
    wait.until { driver.find_elements(:xpath, "//div[@class='catogory']") }

    driver
      .find_elements(:xpath, "//a[@class='btn-link collapse-btn']")
      .first
      .click()

    wait.until { driver.find_elements(:xpath, "//span[@class='icon-label hidden-xs']") }

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

    driver.quit
  end
end
