# Ninja2k::Scraper

This gem allows you to scrape Nokogiri parsable resources for specified
clues and add hooks to define how those clues are processed. It also
lets you export the results into an xlsx file.

## Installation

Add this line to your application's Gemfile:

    gem 'ninja2k-scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ninja2k-scraper

## Usage

# Basic Scraping

```ruby
require 'ninja2k-scraper'

clues = ['Operating system', 'Processors', 'Chipset', 'Memory type', 'Hard drive', 'Graphics',
         'Ports', 'Webcam', 'Pointing device', 'Keyboard', 'Network interface', 'Chipset', 'Wireless',
         'Power supply type', 'Energy efficiency', 'Weight', 'Minimum dimensions (W x D x H)',
         'Warranty', 'Software included', 'Product color']

url =  "http://h10010.www1.hp.com/wwpc/ie/en/ho/WF06b/321957-321957-3329742-89318-89318-5186820-5231694.html?dnr=1"
selector =  "//td[text()='%s']/following-sibling::td"

scraper = Ninja2kScraper::Scraper.new(url, selector, :clues => clues)
scraper.to_xlsx('my_spreadsheet.xlsx')
```


# With Hooks and Styles
```ruby
require 'ninja2k-scraper'

clues = ['Operating system', 'Processors', 'Chipset', 'Memory type', 'Hard drive', 'Graphics',
         'Ports', 'Webcam', 'Pointing device', 'Keyboard', 'Network interface', 'Chipset', 'Wireless',
         'Power supply type', 'Energy efficiency', 'Weight', 'Minimum dimensions (W x D x H)',
         'Warranty', 'Software included', 'Product color']

url =  "http://h10010.www1.hp.com/wwpc/ie/en/ho/WF06b/321957-321957-3329742-89318-89318-5186820-5231694.html?dnr=1"
selector =  "//td[text()='%s']/following-sibling::td"

os_hook =  Proc.new do |element|
             element.inner_html.split('<br>').each do |datum|
               datum.strip!.upcase!
             end
           end


scraper = Ninja2kScraper::Scraper.new(url, selector, :clues => clues, :hooks => { 'Operating system' => os_hook })

# You can also alter the xlsx spreadsheet before serializing.
# See https://github.com/randym/axlsx

package = scraper.to_xlsx false
clue_style = package.workbook.styles.add_style :fg_color => 'FF0000'
package.workbook.worksheets.first.col_style(0, clue_style)
package.serialize('styled.xlsx')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
