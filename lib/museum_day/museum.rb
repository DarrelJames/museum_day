class MuseumDay::Museum

  attr_accessor :name, :city, :url, :address, :phone_number, :website_url, :twitter, :fb,
  :description, :hours, :doc

  @@all = []

  def initialize(attributes)
    @name = attributes[:name]
    @city = attributes[:city]
    @url = attributes[:url]
    @hours = attributes[:hours]
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find(id)
    self.all[id-1]
  end

  def self.clear_all
    @@all.clear
  end
end
