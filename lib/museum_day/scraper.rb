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
      attribute_hash = {
        name: museum.css("h4.name").text,
        city: museum.css("h5.location").text,
        url: museum.css("a").attribute("href").value,
        hours: museum.at("div strong").next_sibling.text.strip
      }
      MuseumDay::Museum.new(attribute_hash)
    end
  end

  def scrape_details(museum)
    doc = Nokogiri::HTML(open("https://www.smithsonianmag.com#{museum.url}"))
    museum.description = doc.css("div.aux-info p").first.text
    museum.address = doc.css("p.address").text.strip
    museum.website_url = doc.css("i.fa-external-link + a").attribute("href").value
    museum.phone_number = doc.at("i.fa-phone").next_sibling.text.strip

    #Scrape Socials
    doc.css("div.contact a").collect { |link| link.attribute("href").value }.each do |link|
      if link.include?("twitter")
        museum.twitter = link
      elsif link.include?("facebook")
        museum.fb = link
      end
    end
  end
end
