require "json"
require "http"
require "optparse"

class DateManager

    ## WELCOME MENU ## 
    def welcome  
        pastel = Pastel.new
        puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:."
        puts "(                                                              )"
        puts " ) "+pastel.bold("Welcome to Date Manager, your all-in-one reservation tool!")+" ("
        puts "(                                                              )"
        puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:."
    end

    def create_menu 
        pastel6 = Pastel.new
        prompt = TTY::Prompt.new
        selection = prompt.select("\nHow can I help you today?") do |menu|
            menu.choice "Create a drinks reservation"
            menu.choice "Create a restaurant reservation"
            menu.choice "Cancel a reservation"
            menu.choice pastel6.red("Exit")
        end
        if selection == pastel6.red("Exit")
            return
        end
        if selection == "Cancel a reservation"
            cancel_a_reservation
        else 
            @zipcode = prompt.ask("Enter your zipcode")
            if selection == "Create a restaurant reservation"
                create_restaurant_reservation
            elsif selection == "Create a drinks reservation"
                create_drinks_reservation
            else
                cancel_a_reservation
            end
        end
    end

    ## DRINKS RESY ## 
    def create_drinks_reservation #brings user to menu to start their drink reservation
        pastel2 = Pastel.new
        prompt = TTY::Prompt.new 
        @drink_type = prompt.select("What type of drink are you looking for?") do |menu|
            menu.choice "Wine"
            menu.choice "Beer"
            menu.choice "Cocktails"
            menu.choice pastel2.red("Main Menu")
        end
        if @drink_type == pastel2.red("Main Menu")
            create_menu
        else
            @date = prompt.ask("What day will your reservation be on? (MM/DD)")
            @time = prompt.ask("What time will your reservation be?")
            @user_name = prompt.ask("What name will the reservation be under?")
            @user = User.create(name: @user_name, location: @zipcode)
            @user.save
            if @drink_type == "Beer"
                puts "Perfect! Here is a list of breweries around #{@zipcode}:"
            elsif @drink_type == "Cocktails"
                puts "Perfect! Here is a list of cocktail bars around #{@zipcode}:"
            else
                puts "Perfect! Here is a list of #{@drink_type.downcase} bars around #{@zipcode}:"
            end
            data = Yelp.search(@drink_type, @zipcode)
            data_hash = data["businesses"]
            search_option(data_hash) 

            confirm = prompt.select("Do you want to make a reservation here?") do |menu|
                menu.choice "Yes"
                menu.choice "No"
            end

            if confirm == "No"
                search_option(data_hash)
            elsif confirm == "Yes"
                @bars = Bar.create(name: :name, type_of_bar: @drink_type, location: @display_adress)
                @reservation = Reservation.create(name_of_customer: @user_name, name_of_business: @picked, time: @time, date: @date)
                system ("clear")
                puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(65) }.join("\n")
                puts ""
                puts pastel2.cyan.bold("You are all set, your reservation is confirmed for #{@time} at #{@picked} on #{@date}!")
                puts ""
                puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(65) }.join("\n")
                create_menu
            end
        end
    end

    ## RESTAURANT RESY ##
    def create_restaurant_reservation #brings user to menu to start their food reservation
        pastel3 = Pastel.new
        prompt = TTY::Prompt.new 
        @cuisine = prompt.select("What cuisine are you looking for?") do |menu|
            menu.choice "American"
            menu.choice "Japanese"
            menu.choice "Italian"
            menu.choice "Tex-Mex"
            menu.choice "Thai"
            menu.choice pastel3.red("Main Menu")
        end
        if @cuisine == pastel3.red("Main Menu")
            create_menu
        else
            @date = prompt.ask("What day will your reservation be on? (MM/DD)")
            @time = prompt.ask("What time will your reservation be?")
            @user_name = prompt.ask("What name will the reservation be under?")
            @user = User.create(name: @user_name, location: @zipcode)
            system ("clear")
            puts "Perfect! Here is a list of #{@cuisine} restaurants around #{@zipcode}:"
            data = Yelp.search(@cuisine, @zipcode)
            data_hash = data["businesses"]
            search_option(data_hash) 

            confirm = prompt.select("Do you want to make a reservation here?") do |menu|
                menu.choice "Yes"
                menu.choice "No"
            end

            if confirm == "No"
                search_option(data_hash)
            elsif confirm == "Yes"
                @restaurant = Restaurant.create(name: @picked, cuisine: @cuisine, location: @display_adress)
                @reservation = Reservation.create(name_of_customer: @user_name, name_of_business: @picked, time: @time, date: @date)
                system ("clear")
                puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(65) }.join("\n")
                puts ""
                puts pastel3.cyan.bold("You are all set, your reservation is confirmed for #{@time} at #{@picked} on #{@date}!")
                puts ""
                puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(65) }.join("\n")
                create_menu
            end
        end
    end

    
    ## CONFIRM A RESY ##
    def search_option(data_hash) #Provides menu options for restaurants, allows us to create reservation or go back to list
        pastel4 = Pastel.new
        prompt = TTY::Prompt.new
        @picked = prompt.select("Which spot do you want to look into?") do |menu|
            data_hash.each do |businesses|
                menu.choice businesses['name']
            end
            menu.choice pastel4.red("Main Menu")
        end

        if @picked == pastel4.red("Main Menu")
            create_menu
        else 
            get_info_for = data_hash.find do |businesses| 
                businesses['name'] == @picked 
            end
            name = get_info_for['name']
            rating = get_info_for['rating']
            get_location = get_info_for['location']
            @display_address = get_location['display_address']
            system ("clear")
            puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(55) }.join("\n")
            puts ""
            puts "#{name}, #{rating}/5 stars".lines.map { |line| line.strip.center(60) }.join("\n")
            puts 
            puts pastel4.white(get_location['display_address']).lines.map { |line| line.strip.center(65) }.join("\n")
            puts ""
            puts ".:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.".lines.map { |line| line.strip.center(55) }.join("\n")
            puts ""
        end
    end
    
    ## CANCEL A RESY ##
    def cancel_a_reservation
        pastel5 = Pastel.new
        prompt = TTY::Prompt.new 
        resy_name = prompt.ask("Let's find your reservation! What name would it be under?")
        find_name = Reservation.where(name_of_customer: resy_name)

        resy_cancel = prompt.select("Which reservation do you want to cancel?") do |menu| 
            choices = find_name.each do |resy|
                menu.choice resy.name_of_business
            end
            menu.choice pastel5.red("Main Menu")
            if choices == []
                puts 
                puts pastel5.red.bold("You currently have no reservations!")
                create_menu
            end
        end
        
        if resy_cancel === pastel5.red("Main Menu")
            create_menu
        else 
            find_time = Reservation.where(name_of_business: resy_cancel)
            resy_time = find_time.map { |resy| resy.time.to_s }.join(',')
            resy_date = find_time.map { |resy| resy.date.to_s }.join(',')
            confirm_delete = prompt.select("Do you want to cancel your reservation at #{resy_cancel} at #{resy_time} on #{resy_date}?") do |menu|
                menu.choice "Yes"
                menu.choice "No"
            end
            if confirm_delete = "Yes"
                cancel_it = Reservation.where(name_of_business: resy_cancel)
                cancel_it.delete_all
                system ("clear")
                puts " :.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:.:"
                puts "(                                     )"
                puts " ) " + pastel5.red.bold("Ok, your reservation is canceled!")+" ( "
                puts "(                                     )"
                puts " :.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:.:"
                create_menu
            else 
                create_menu
            end
            return
        end
    end

end
