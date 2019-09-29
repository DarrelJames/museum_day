class MuseumDay::Museum

  attr_accessor :name, :city, :url, :address, :phone_number, :website_url, :twitter, :fb,
  :description, :hours, :doc

  @@all = []

  def self.new_from_index(museum)
    self.new(
      museum.css("h4.name").text,
      museum.css("h5.location").text,
      museum.css("a").attribute("href").value,
      museum.at("div strong").next_sibling.text.strip
    )
  end

  def initialize(name = nil, city = nil, url = nil, hours = nil)
    @name = name
    @city = city
    @url = url
    @hours = hours
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find(id)
    self.all[id-1]
  end

  def address
    @address ||= doc.css("p.address").text.strip
  end

  def phone_number
    @phone_number ||= doc.at("i.fa-phone").next_sibling.text.strip
  end

  def website_url
    @website_url ||= doc.css("i.fa-external-link + a").attribute("href").value
  end

  def social_urls
    social_links = doc.css("div.contact a").collect { |link| link.attribute("href").value }

    social_links.each do |link|
      if link.include?("twitter")
        self.twitter = link
      elsif link.include?("facebook")
        self.fb = link
      end
    end
  end

  def description
    @description ||= doc.css("div.aux-info p").first.text
  end

  def doc
    @doc ||= Nokogiri::HTML(open("https://www.smithsonianmag.com#{self.url}"))
  end

  def self.clear_all
    @@all.clear
  end
end
