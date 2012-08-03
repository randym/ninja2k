# encoding: UTF-8
require 'test_helper'

class TestScraper < Test::Unit::TestCase

  def setup
    @clues = ['Operating system', 'Processors', 'Chipset', 'Memory type', 'Hard drive', 'Graphics',
         'Ports', 'Webcam', 'Pointing device', 'Keyboard', 'Network interface', 'Chipset', 'Wireless',
         'Power supply type', 'Energy efficiency', 'Weight', 'Minimum dimensions (W x D x H)',
         'Warranty', 'Software included', 'Product color']

     @url =  "#{File.dirname(__FILE__)}/support/products.html"
     @selector =  "//td[text()='%s']/following-sibling::td"
     @scraper = ::Ninja2kScraper::Scraper.new(@url, @selector, :clues => @clues)
     @output = [["Operating system", "Windows® 7 Home Premium 64"], ["Processors", "• 1.3 GHz"], ["", "AMD Dual-Core E-300 APU with Radeon HD 6310 Discrete-Class Graphics"], ["Chipset", "AMD A50M FCH"], ["Memory type", "4 GB DDR3"], ["Hard drive", "500 GB SATA (5400 rpm)"], ["Graphics", "AMD Radeon HD 6310 Discrete-Class (up to 1.92 GB total memory)"], ["Ports", "1 RJ45"], ["", "1 VGA"], ["", "1 Headphone-out"], ["", "1 Microphone-in"], ["", "3 USB 2.0"], ["Webcam", "HP Webcam with Integrated Digital Microphone (VGA)"], ["Pointing device", "TouchPad with on/off button and support for multitouch gestures"], ["Keyboard", "Full size keyboard with 6 function cells"], ["Network interface", "Integrated 10/100 BASE-T Ethernet LAN"], ["Chipset", "AMD A50M FCH"], ["Wireless", "802.11 b/g/n"], ["Power supply type", "65W AC Power Adapter"], ["Energy efficiency", "ENERGY STAR® qualified; EPEAT® Silver"], ["Weight", "Starting at 2.55 kg"], ["Minimum dimensions (W x D x H)", "37.6 x 24.7 x 3.58 cm"], ["Warranty", "1 year, pick-up and return, parts and labour"], ["Software included", "Microsoft® Office Starter: reduced-functionality Word and Excel® only, with advertising. No PowerPoint® or Outlook®. Buy Office 2010 to use the full featured software."], ["", "Symantec Norton Internet Security (60 days live update)"], ["", "Recovery partition (including possibility to recover system"], ["", "applications and drivers separately)"], ["", "Optional re-allocation of recovery partition"], ["", "Recovery CD/DVD creation tool"], ["", "Notebook Help &amp; Support"], ["", "HP Setup Manager"], ["", "HP Support Assistant"], ["", "HP Recovery Manager"], ["", "Cyberlink YouCam DE"], ["", "Windows Live Essentials"], ["", "HP Games powered by WildTangent"], ["", "Adobe Reader"], ["", "Adobe Flash Player"], ["", "EasyBits Magic Desktop"], ["", "HP Launch Box"], ["", "Evernote"], ["", "HP+"], ["", "HP Rara Music"], ["", "HP Security Assistant"], ["Product color", "Black"]]

  end

  def test_initialize
    assert_equal(@clues, @scraper.clues)
    assert_equal(@url, @scraper.url)
    assert_equal(@selector, @scraper.selector)
  end
  
  def test_scrape
    assert(@scraper.scrape.is_a?(Array))
    assert_equal(@output, @scraper.output)
  end

  def test_hooks
    @scraper.add_hook('Operating system', Proc.new { |element| element.inner_html.split('<br>').each(&:strip!).each(&:upcase!) })
    @scraper.scrape
    assert_equal(@output[0][1].upcase, @scraper.output[0][1])
  end

  def test_to_xlsx
    @scraper.to_xlsx false
    assert_equal('Operating system', @scraper.package.workbook.worksheets.first['A1'].value)
  end
end
