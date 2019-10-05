class MuseumDay::CLI
  attr_accessor :zipcode

  def call
    puts "--------------Welcome to Museum Day--------------"
    start
  end


  def start

    get_zipcode if !zipcode

    exit?(zipcode)

    list_museums(zipcode)

    get_user_input_for_details_and_print

    menu

    input = gets.strip.downcase
    exit?(input)

    new_or_back?(input)

  end

  def list_museums(input)

    @scraper = MuseumDay::Scraper.new(input)
    @scraper.make_museums

    puts "\n--------------Listing museums near #{zipcode}--------------"

    MuseumDay::Museum.all.each.with_index(1) do |museum, idx|
      puts "#{idx}. #{museum.name} - #{museum.city}"
    end
  end

  def print_museum_details(input)

    museum = MuseumDay::Museum.find(input.to_i)

    @scraper.scrape_details(museum)

    puts "\n--------------#{museum.name}--------------"
    puts "#{museum.address}"
    puts "       #{museum.hours}"
    puts "\nPhone Number: #{museum.phone_number}"
    puts "Website:      #{museum.website_url}"
    puts "Facebook:     #{museum.fb}" if museum.fb
    puts "Twitter:      #{museum.twitter}" if museum.twitter
    puts "\n--------------Description--------------"
    puts "#{museum.description}"
  end

  def get_user_input_for_details_and_print
    input = 0

    while !input.to_i.between?(1, MuseumDay::Museum.all.size)
      puts "\nEnter the number of the museum you'd like more info on or type exit"
      input = gets.strip

      exit?(input)
      if input.to_i.between?(1, MuseumDay::Museum.all.size)
        print_museum_details(input)
      else
        puts "Invalid number"

      end
    end
  end

  def menu
    puts "\n---------------------------------------------"
    puts "To go back to list of museums, enter 'back'."
    puts "To search a new zipcode, enter 'new'."
    puts "To quit, enter 'exit'."
    puts "---------------------------------------------"
  end

  def get_zipcode
    puts "\nPlease enter your zipcode or type exit"

    self.zipcode = gets.strip
    exit?(zipcode)

    if zipcode.size != 5
      puts "\nInvalid Zipcode"
      get_zipcode
    end
  end

  def new_or_back?(input)
    if input ==  "new"
      MuseumDay::Museum.clear_all
      self.zipcode = nil
      start
    elsif input == "back"
      MuseumDay::Museum.clear_all
      start
    end
  end

  def exit?(input)
    goodbye if input.downcase == "exit"
  end

  def goodbye
    puts "-----------------"
    puts "|    Goodbye    |"
    puts "-----------------"
    exit
  end
end
