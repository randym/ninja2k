clues = ['Operating system', 'Processors', 'Chipset', 'Memory type', 'Hard drive', 'Graphics',
         'Ports', 'Webcam', 'Pointing device', 'Keyboard', 'Network interface', 'Chipset', 'Wireless',
         'Power supply type', 'Energy efficiency', 'Weight', 'Minimum dimensions (W x D x H)',
         'Warranty', 'Software included', 'Product color']

url =  "http://h10010.www1.hp.com/wwpc/ie/en/ho/WF06b/321957-321957-3329742-89318-89318-5186820-5231694.html?dnr=1"
selector =  "//td[text()='%s']/following-sibling::td"

scraper = Ninja2k::Scraper.new(url, selector, :clues => clues)
scraper.to_xlsx('my_spreadsheet.xlsx')

