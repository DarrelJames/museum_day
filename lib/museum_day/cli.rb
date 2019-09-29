class MuseumDay::CLI
  attr_accessor :zipcode

  def call
    puts "--------------Welcome to Museum Day--------------"
    start
  end


  def start
    if !zipcode
      get_zipcode
    end

    exit?(zipcode)
    list_museums(zipcode)

    input = 0

    while !input.to_i.between?(1, MuseumDay::Museum.all.size)
      puts ""
      puts "Enter the number of the museum you'd like more info on or type exit"
      input = gets.strip

      exit?(input)
      if input.to_i.between?(1, MuseumDay::Museum.all.size)
        print_museum_details(input)
      else
        puts "Invalid number"

      end
    end

    menu

    input = gets.strip.downcase
    exit?(input)

    if input ==  "new"
      MuseumDay::Museum.clear_all
      @zipcode = nil
      start
    elsif input == "back"
      MuseumDay::Museum.clear_all
      start
    end
  end

  def list_museums(input)

    MuseumDay::Scraper.new(input).make_museums

    puts ""
    puts "--------------Listing museums near #{zipcode}--------------"

    MuseumDay::Museum.all.each.with_index(1) do |museum, idx|
      puts "#{idx}. #{museum.name} - #{museum.city}"
    end
  end

  def get_zipcode
    puts ""
    puts "Please enter your zipcode or type exit"

    @zipcode = gets.strip

    if zipcode.size != 5
      puts ""
      puts "Invalid Zipcode"
      get_zipcode
    end
  end

  def print_museum_details(input)

    museum = MuseumDay::Museum.find(input.to_i)

    puts ""
    puts "--------------#{museum.name}--------------"
    puts "#{museum.address}"
    puts "      Hours: #{museum.hours}"
    puts ""
    puts "Phone Number: #{museum.phone_number}"
    puts "Website:      #{museum.website_url}"

    museum.social_urls
    if museum.fb
      puts "Facebook:     #{museum.fb}"
    end

    if museum.twitter
      puts "Twitter:      #{museum.twitter}"
    end

    puts ""
    puts "--------------Description--------------"
    puts "#{museum.description}"
  end

  def menu
    puts ""
    puts "To go back to list of museum, enter 'back'."
    puts "To search a new zipcode, enter 'new'."
    puts "To quit, enter 'exit'."
  end

  def exit?(input)
    if input.downcase == "exit"
      goodbye
    end
  end

  def goodbye
    puts "-----------------"
    puts "|    Goodbye    |"
    puts "-----------------"
    exit
  end
end
