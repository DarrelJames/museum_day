class MuseumDay::Scraper

  attr_accessor :zipcode

  def initialize(zipcode)
    @zipcode = zipcode
  end

  def get_museums_page
    Nokogiri::HTML(open("https://www.smithsonianmag.com/museumday/search/?q=&around_zip=#{zipcode}"))
  end

  def scrape_museums_index
    self.get_museums_page.css("div.museum div.museum-text")
  end

  def make_museums
    scrape_museums_index.each do |museum|
      MuseumDay::Museum.new_from_index(museum)
    end
  end

end
