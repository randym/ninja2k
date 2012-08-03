require 'nokogiri'
require 'open-uri'
require 'axlsx'

module Ninja2k


  # Scraper will load up a specified resource, and search the page using a combination of your seletor and any clues given.
  # It provides a hooking mechanism so you can override the default parsing action (split on <br>, one row for each item found)
  #
  # @example 
  #     clues = ['Operating system', 'Processors', 'Chipset', 'Memory type', 'Hard drive', 'Graphics',
  #       'Ports', 'Webcam', 'Pointing device', 'Keyboard', 'Network interface', 'Chipset', 'Wireless',
  #       'Power supply type', 'Energy efficiency', 'Weight', 'Minimum dimensions (W x D x H)',
  #       'Warranty', 'Software included', 'Product color']
  #
  #     url =  "http://h10010.www1.hp.com/wwpc/ie/en/ho/WF06b/321957-321957-3329742-89318-89318-5186820-5231694.html?dnr=1"
  #     selector =  "//td[text()='%s']/following-sibling::td"
  #
  #     scraper = Ninja2k::Scraper.new(url, selector, :clues => clues)
  #     scraper.to_xlsx('my_spreadsheet.xlsx')
  class Scraper

    # Creates a new Scraper
    #
    # @param [String] url The resource to scrape
    #
    # @param [String] selector The xpath select to use when searching for clues. Use %s in the selector to interpolate each clue
    #
    # @param [Hash] options each option will be evaluated against a attr_writer using respond_to? If a writer exists, the value for the option is passed to the writer.
    #
    # @option [Array] clues The clues to search for
    #
    # @option [Hash] hooks A hash of hooks where the key is the clue name the Proc value will be caled against.
    def initialize(url, selector, options={})
      self.url = url
      self.selector = selector
      options.each do |o|
        self.send("#{o[0]}=", o[1]) if self.respond_to? "#{o[0]}="
      end
    end

    # The url we will scrape from
    # @return [String]
    attr_accessor :url

    # The xpath selector to use when searching for clues
    # @return [String]
    attr_accessor :selector

    # The output from scraping as an array
    # This is populated by the scrape or to_xlsx methods
    #
    # @return [Array]
    def output
      @output ||= []
    end

    # A hash of Proc object to call when parsing each item found by the selector and clue combination.
    # The element found will be passed to the member of this hash that uses the clue as a key
    #
    # @see example/example.rb
    #
    # @return [Hash]
    def hooks
      @hooks ||= {}
    end

    # @see hooks
    def hooks=(hash)
      raise ArgumentError, 'Hooks must be a hash of procs to call when scraping each clue' unless hash.is_a?(Hash)
      @hooks = hash
    end

    # Adds a hook to the hook hash
    #
    # @param [String] clue the clue this hook will be called for
    #
    # @param [Proc] p_roc the Proc to call when the clue is found
    def add_hook(clue, p_roc)
      hooks[clue] = p_roc
    end

    # Scrapes the resourse using the clues and hooks provided
    #
    # @return [Array]
    def scrape
      @output = []
      clues.each do |clue|
        if detail = parse_clue(clue)
          output << [clue, detail.pop]
          detail.each { |datum| output << ['', datum] }
        end
      end
      output
    end

    # seralizes the output to xlsx. If you specify false for the file_name parameter
    # The package will be created, but not serialized to disk. This means you can use the return value
    # to stream the data using to_xlsx(false).to_stream.read
    #
    # @param [String] filename the filename to use in output
    #
    # @return [Axlsx::Package]
    def to_xlsx(filename)
      scrape
      serialize(filename)
    end
    
    # The clues we are going to look for with the selector in the document returned by url
    #
    # @return [Array]
    def clues
      @clues ||= []
    end

    # Sets the clues for the scraper
    #
    # @param [Arrray] value The clues to look for.
    def clues=(value)
      raise ArugmentError, 'clues must be an array of strings to search for with your selector' unless value.is_a?(Array)
      @clues = value
    end

    # The axlsx package used for xlsx serialization
    #
    # @return [Axlsx::Package]
    def package
      @package ||= Axlsx::Package.new
    end

    private

    def doc
      @doc ||= begin 
                 Nokogiri::HTML(open(@url))
               rescue
                 raise ArgumentError, 'Invalid URL - Nothing to parse'
               end
    end

    def selector_for_clue(clue)
      @selector % clue
    end

    def parse_clue(clue)
      if element = doc.at(selector_for_clue(clue))
        call_hook(clue, element) || element.inner_html.split('<br>').each(&:strip!)
      end
    end

    def call_hook(clue, element)
      if hooks[clue].is_a? Proc
        value = hooks[clue].call(element)
        value.is_a?(Array) ? value : [value]
      end
    end

    def serialize(file_name=nil)
      package.workbook.add_worksheet do |sheet|
        output.each { |datum| sheet.add_row datum }
      end
      package.serialize(file_name) if file_name
      package
    end
  end
end
