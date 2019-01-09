class LiquerY::CLI

  def call
    welcome
    compile
    main_menu
  end

  def welcome
    puts <<~EOC.cyan

             -- Welcome to LiquerY --

           Liquery is a games-style CLI app
      built to help its users better understand
        their palates for cocktails & drinks.

    We hope you have fun playing around with our app,
  and we hope that, in the process, we can help you learn
       about new & exciting beverages to enjoy,
  whether you're out on the town or entertaining at home!

             Please wait just a moment
       as we compile our database of cocktails
              and user preferences!

           ----------------------------

    EOC
  end

  def compile
    spinner = ::TTY::Spinner.new("                  [:spinner]".light_blue, format: :bouncing)
    spinner.auto_spin
    Drink.all
    spinner.stop('Done!'.cyan)
  end

  def main_menu
    if !(User.current_user)
      puts "\nIt seems that you're here for the first time!".light_blue
      puts "To start, we'll have you begin by taking our quiz,".light_blue
      puts "so that we can get a sense for your likes & dislikes!".light_blue
      self.drink_quiz
    else
      system "clear"
      puts "Main Menu:".light_blue
      puts "Now that you've completed our quiz, we have a few".cyan
      puts "other services that may be helpful to you!".cyan
      self.list_menu_options
    end
  end



  ## ------------ ##
  ## MENU METHODS ##
  ## ------------ ##

  def list_menu_options
    puts "\n\t[1.] ".cyan + "See a list of your liked & recommended drinks".light_blue
    puts "\t[2.] ".cyan + "Search our entire repertoire of cocktails".light_blue
    puts "\t[3.] ".cyan + "Take our quiz again to update your preferences".light_blue
    puts "\t...or type ".light_blue + "\'exit\'".cyan + " to leave the app.".light_blue
    begin
      print "\nYour selection: ".cyan
      input = gets.chomp
      case input
      when "1"
        system "clear"
        self.list_liked_and_recommended
      when "2"
        self.list_search_options
      when "3"
        self.drink_quiz
      when "exit"
        self.exit
      else
        puts "Whoops, \'#{input}\' isn't an option!".light_blue
      end
    end until ["1", "2", "3", "exit"].include?(input)
  end

  def list_liked_and_recommended
    puts "Liked & Recommended Drinks:".light_blue
    User.current_user.list_liked_drinks
    puts "\nWould you like to see...".cyan + "\n[1.]".light_blue + " the ingredients for one of these drinks or ".cyan + "\n[2.]".light_blue + " learn how to mix one of them?".cyan
    begin
      print "Enter ".cyan + "\"1\"".light_blue + ", ".cyan + "\"2\"".light_blue + ", or ".cyan + "\"menu\"".light_blue + " to return to menu... ".cyan
      input = gets.chomp
      case input
      when "1"
        self.user_local_ingredient_search
        self.main_menu
      when "2"
        self.user_local_recipe_search
        self.main_menu
      when "menu"
        self.main_menu
      else
        puts "Whoops, \'#{input}\' isn't an option!".light_blue
      end
    end until ["1", "2", "menu"].include?(input)
  end

  def user_local_ingredient_search
    puts "\nWhich drink would you like to see the ingredients for?".light_blue
    print "Type the drink name here: ".light_blue
    input = gets.chomp.capitalize
    Drink.find_ingredients_by_drink_name(input)
    puts "\n--------------------------------------".light_blue
    puts "\nPress [Enter] to return to the main menu..."
    STDIN.getch
  end

  def user_local_recipe_search
    puts "\nWhich drink would you like to see mixing instructions for?".light_blue
    print "Type the drink name here: ".light_blue
    input = gets.chomp.capitalize
    Drink.find_recipe_by_drink_name(input)
    puts "\n--------------------------------------".light_blue
    puts "\nPress [Enter] to return to the main menu..."
    STDIN.getch
  end

  def list_search_options
    system "clear"
    puts "Search Cocktails:".light_blue
    puts "How would you like to begin your search?".cyan
    puts "\n\t[1.] ".cyan + "Search by variety of alcohol or ingredient".light_blue
    puts "\t[2.] ".cyan + "Search by name of drink".light_blue
    puts "\t[3.] ".cyan + "Search by palate keywords\n".light_blue
    begin
      print "Your selection: ".cyan
      input = gets.chomp
      case input
      when "1"
        self.menu_search_by_alcohol
        self.main_menu
      when "2"
        self.menu_search_by_drink_name
        self.main_menu
      when "3"
        self.menu_search_by_palate_keyword
        self.main_menu
      else
        puts "Whoops, \'#{input}\' isn't an option!".light_blue
      end
    end until ["1", "2", "3"].include?(input)
  end

  def menu_search_by_alcohol
    print "\nType the alcohol or ingredient name here: ".light_blue
    name = gets.chomp
    drink_array = Drink.search_by_alcohol_name(name)
    puts "\nHere are all the drinks we know with ".cyan + "#{name.upcase} ".light_blue + "in them:".cyan
    a = drink_array.each.with_index(1) {|d, i| puts "\t#{i}. #{d.strDrink}".light_blue}
    puts "Which drink would you like to know more about?".cyan
    begin
      print "Type the number of the drink here: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, a) == true
    self.menu_search_by_drink_name(a[input.to_i - 1].strDrink)
  end

  def menu_search_by_drink_name(name = nil)
    if !(name)
      print "\nType the drink name here: ".light_blue
      name = gets.chomp
    end
    drink = Drink.search_by_drink_name(name)
    puts "\nWould you like to see the ".cyan + "[recipe]".light_blue + " or ".cyan + "[ingredients]".light_blue + " of #{drink.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{drink.strDrink.upcase}?".cyan
    puts "...or would you like to ".cyan + "[add]".light_blue + " it to your list of \'liked drinks\'?".cyan
    begin
      print "Your selection: ".cyan
      input = gets.chomp
      case input
      when "recipe"
        Drink.find_recipe_by_drink_name(drink.strDrink)
        self.add_or_return(drink)
      when "ingredients"
        Drink.find_ingredients_by_drink_name(drink.strDrink)
        self.add_or_return(drink)
      when "add"
        User.current_user.liked_drinks << drink
        puts "\nAwesome! We've added ".light_blue + drink.strDrink.upcase.cyan + " to your list of \'liked drinks\'.".light_blue
        puts "\nPress [Enter] to return to the main menu..."
        STDIN.getch
      else
        puts "Whoops, \'#{input}\' isn't an option!".light_blue
      end
    end until input == "recipe" || input == "ingredients" || input == "add" || input == "menu"
  end

  def menu_search_by_palate_keyword
    puts "\nWould you like to search for a ".light_blue + "dry".cyan + ", ".light_blue + "sweet".cyan + ", ".light_blue + "creamy".cyan + ", or ".light_blue + "bright ".cyan + "drink?".light_blue
    begin
      print "Your selection: ".cyan
      input = gets.chomp
      puts "Whoops, \'#{input}\' isn't an option!".light_blue unless ["dry", "sweet", "creamy", "bright"].include?(input)
    end until ["dry", "sweet", "creamy", "bright"].include?(input)
    drink_array = Drink.search_by_palate(input)
    puts "Here are all the drinks we know with a ".cyan + "#{input.upcase} ".light_blue + "palate:".cyan
    a = drink_array.each.with_index(1) {|d, i| puts "\t#{i}. #{d.strDrink}".light_blue}
    puts "Which drink would you like to know more about?".cyan
    begin
      print "Type the number of the drink here: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, a) == true
    self.menu_search_by_drink_name(a[input.to_i - 1].strDrink)
  end

  def add_or_return(drink)
    puts "\nType ".cyan + "[menu]".light_blue + " to return to the previous menu, or".cyan
    puts "type ".cyan + "[add]".light_blue + " to add this drink to your list of \'liked drinks\'".cyan
    begin
      print "Your selection: ".cyan
      input = gets.chomp
      case input
      when "add"
        User.current_user.liked_drinks << drink
        puts "\nAwesome! We've added ".light_blue + drink.strDrink.upcase.cyan + " to your list of \'liked drinks\'.".light_blue
        puts "\nPress [Enter] to return to the main menu..."
        STDIN.getch
      else
        puts "Whoops, \'#{input}\' isn't an option!".light_blue unless input == "menu"
      end
    end until input == "menu" || input == "add"
  end

  def exit
    puts "\nThanks for stopping by! Have a great day!".cyan
  end

  ## ------------ ##
  ## QUIZ METHODS ##
  ## ------------ ##

  def drink_quiz
    puts "\nAre you ready to take our quiz? [Press Enter to begin]..."
    STDIN.getch
    system "clear"

    User.current_user || User.new
    self.offer_main_test
    self.offer_sub_test

    puts "\nDepending on your answers, we may have a few"
    puts "more questions for you... [Press Enter to continue]"
    STDIN.getch
    system "clear"

    self.test_dislikes

    User.current_user.quiz_results ||= []
    User.current_user.okay_drinks = (self.calculate_okay_drinks || [])
    User.current_user.great_drinks = (self.calculate_great_drinks || [])

    puts "\nThanks for completing our quiz!! Now give us just one second as"
    puts "we find a drink you're sure to enjoy! [Press Enter to Continue...]"
    STDIN.getch
    system "clear"

    self.return_quiz_results

    puts "\nWe're ready to return to the main menu! [Press Enter to continue]..."
    STDIN.getch
    system "clear"
    self.main_menu
  end

  def offer_main_test
    puts "LiquerY Quiz:".light_blue
    puts "Listed below are some classic cocktails. Pick the one you enjoy the most!".cyan
    a = Drink.select_for_test.each.with_index(1) { |x, i| puts "#{i}. #{x.strDrink}".center(30)}
    begin
      print "Your favorite: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, a) == true
    User.current_user.liked_drinks << a[input.to_i - 1]
    system "clear"
    puts "LiquerY Quiz:".light_blue
    puts "Gotcha! So of those drinks, your favorite is #{User.current_user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.recent_choice.strDrink}?".cyan
  end

  def offer_sub_test
    puts "\nIf you had to pick one other drink from this smaller list,".light_blue
    puts "what would it be?".light_blue
    b = Drink.select_for_test.each.with_object([]) do |drink, array|
      User.current_user.recent_choice.all_ingredients.each do |ingredient|
        array << drink if drink.all_ingredients.include?(ingredient)
      end
    end.uniq.reject{|d| d == User.current_user.recent_choice}
    b.each.with_index(1) { |x, i| puts "#{i}. #{x.strDrink}".center(30)}
    begin
      print "Your choice: ".light_blue
      input = gets.chomp
    end until self.safe_input?(input, b) == true
    User.current_user.liked_drinks << b[input.to_i - 1]
    User.current_user.add_to_liked_ingredients
    system "clear"
    puts "LiquerY Quiz:".light_blue
    puts "Super! So although your 1st choice was #{User.current_user.liked_drinks[-2].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.liked_drinks[-2].strDrink},".cyan
    puts "you also could find yourself enjoying #{User.current_user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.recent_choice.strDrink}.".cyan
  end

  def test_dislikes
    bad_drinks = Drink.select_for_test.select do |drink|
      User.current_user.liked_ingredients.size >= 10 ? (drink.all_ingredients & User.current_user.liked_ingredients).size < 2 : (drink.all_ingredients & User.current_user.liked_ingredients).empty?
    end
    bad_drinks -= User.current_user.disliked_drinks
    unless bad_drinks.empty?
      puts "LiquerY Quiz:".light_blue
      puts "Given the cocktails you've identified so far, we're noticing".cyan #3. test for dislikes
      puts "that you might not enjoy the palates of some of these drinks:".cyan
      bad_drinks.each.with_index(1) { |x, i| puts "#{i}. #{x.strDrink}".center(30)}
      puts "Is there one drink on this list that you absolutely cannot stand?".cyan
      begin
        print "If so, type that drink's number, otherwise type [none]: ".light_blue
        input = gets.chomp
      end until (self.safe_input?(input, bad_drinks) == true) || (input == "none")
      if input == "none"
        User.current_user.disliked_drinks << Drink::DUMMY_DRINK if User.current_user.disliked_drinks.empty?
        system "clear"
        puts "LiquerY Quiz:".light_blue
        puts "Perfect! It makes our job a little easier if you have an open mind & palate!".cyan
      else
        User.current_user.disliked_drinks << bad_drinks[input.to_i - 1]
        User.current_user.liked_drinks -= (User.current_user.liked_drinks & User.current_user.disliked_drinks)
        system "clear"
        puts "LiquerY Quiz:".light_blue
        puts "Blech! You just do not enjoy #{User.current_user.disliked_drinks[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.disliked_drinks[-1].strDrink}.".cyan
        puts "We hear you! And that's great to know!".cyan
      end
    else # i.e. if bad_drinks.empty?
      puts "LiquerY Quiz:".light_blue
      puts "Actually, we don't think we have any further questions for you!".cyan
    end
  end

  def calculate_okay_drinks
    Drink.all.select do |drink| #4. calculate User.current_user.s "okay_drinks" array
      if (User.current_user.liked_drinks + User.current_user.disliked_drinks + User.current_user.quiz_results).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & User.current_user.liked_ingredients).size > 0 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & User.current_user.liked_ingredients).size > 1 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
  end

  def calculate_great_drinks
    array = Drink.all.select do |drink| # 5. calculate User.current_user.s "great_drinks array"
      if (User.current_user.liked_drinks + User.current_user.disliked_drinks + User.current_user.quiz_results).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & User.current_user.liked_ingredients).size > 1 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & User.current_user.liked_ingredients).size > 2 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
  end

  def return_quiz_results
    User.current_user.great_drinks.size > 1 ? drink = User.current_user.great_drinks.sample : drink = User.current_user.okay_drinks.sample
    User.current_user.quiz_results << drink
    if Drink.select_for_test.include?(drink)
      puts "The answer was under our noses the entire time!".center(59).light_blue
      puts "We know we've asked you about this drink in the list above,".light_blue
      puts "but we're totally positive that you would love #{User.current_user.quiz_results[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(59).light_blue
      puts "\n"
      puts "#{drink.strDrink}!".center(59).cyan
      puts "It's made with #{drink.print_ingredients}".center(59).cyan
      puts "\n"
      puts "Give it a whirl, if you haven't tried one before!".center(59).light_blue
      puts "\n"
    elsif User.current_user.great_drinks.include?(drink)
      puts "So, we had to look into some of our more obscure".center(61).light_blue
      puts "cocktail recipes to find something just perfect for you".center(61).light_blue
      puts "but we're still totally certain that you're going to love it!".light_blue
      puts "\n"
      puts "The #{drink.strDrink}!".center(61).cyan
      puts "It's made with #{drink.print_ingredients}".center(61).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(61).light_blue
      puts "\n"
    else
      puts "We have to admit it... you nearly stumped us there!".center(64).light_blue
      puts "Sometimes drink preferences aren't exactly data science,".light_blue
      puts "but we're still decently confident that you'd enjoy #{drink.strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(64).light_blue
      puts "\n"
      puts "#{drink.strDrink}!".center(64).cyan
      puts "It's made with #{drink.print_ingredients}".center(64).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(64).light_blue
      puts "\n"
    end
  end

  def safe_input?(input, array)
    input_max_range = array.size
    if (1..input_max_range).include?(input.to_i)
      true
    else
      puts "Sorry, that selection is invalid. Mind trying again?".light_blue
      false
    end
  end




end
