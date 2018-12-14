require "tty-spinner"
require "io/console"

class LiquerY::CLI

  def call
    welcome
    compile
    main_menu
    drink_quiz
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
    Drink.new_from_hash#(DrinkAPI.new.make_hash)
    spinner.stop('Done!'.light_blue)
  end

  def main_menu
    puts "\nAre you ready to take our quiz? [Press Enter to begin]..."
    STDIN.getch
  end

  def drink_quiz
    User.new
    self.offer_main_test
    self.offer_sub_test

    puts "\nJust a few more questions! [Press Enter to continue]..."
    STDIN.getch

    self.test_dislikes

    User.current_user.okay_drinks = self.calculate_okay_drinks
    User.current_user.great_drinks = self.calculate_great_drinks

    puts "\nThanks for completing our quiz!! Now give us just one second as"
    puts "we find a drink you're sure to enjoy! [Press Enter to Continue...]"
    STDIN.getch

    self.return_quiz_results

  end

  def offer_main_test
    puts "\nListed below are some classic cocktails. Pick the one you enjoy the most!".cyan #1. list test cocktails
    a = Drink.select_for_test.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    begin
      print "Your favorite: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, a) == true
    User.current_user.liked_drinks << a[input.to_i - 1]
    puts "\nGotcha! So of the drinks above, your favorite is #{User.current_user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.recent_choice.strDrink}?".light_blue
  end

  def offer_sub_test
    puts "\nIf you had to pick one other drink from this smaller list,".cyan#2. list subtest cocktails
    puts "what would it be?".cyan
    b = Drink.select_for_test.each.with_object([]) do |drink, array|
      User.current_user.recent_choice.all_ingredients.each do |ingredient|
        array << drink if drink.all_ingredients.include?(ingredient)
      end
    end.uniq.reject{|d| d == User.current_user.recent_choice}
    b.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    begin
      print "Your choice: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, b) == true
    User.current_user.liked_drinks << b[input.to_i - 1]
    User.current_user.add_to_liked_ingredients
    puts "\nSuper! So although your 1st choice was #{User.current_user.liked_drinks[-2].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.liked_drinks[-2].strDrink},".light_blue
    puts "you also could find yourself enjoying #{User.current_user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.recent_choice.strDrink}.".light_blue
  end

  def test_dislikes
    puts "\nGiven the cocktails you've identified so far, we're noticing".cyan #3. test for dislikes
    puts "that you might not enjoy the palates of some of these drinks:".cyan
    bad_drinks = Drink.select_for_test.select do |drink|
      (drink.all_ingredients & User.current_user.liked_ingrdients).empty?
    end
    bad_drinks.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    puts "Is there one drink on this list that you absolutely cannot stand?".cyan
    begin
      print "Your choice: ".cyan
      input = gets.chomp
    end until self.safe_input?(input, bad_drinks) == true
    User.current_user.disliked_drinks << bad_drinks[input.to_i - 1]
    puts "\nBlech! You just do not enjoy #{User.current_user.disliked_drinks[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{User.current_user.disliked_drinks[-1].strDrink}.".light_blue
    puts "We hear you! And that's great to know!".light_blue
  end

  def calculate_okay_drinks
    Drink.all.select do |drink| #4. calculate User.current_user.s "okay_drinks" array
      if (User.current_user.liked_drinks + User.current_user.disliked_drinks).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & User.current_user.liked_ingrdients).size > 0 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & User.current_user.liked_ingrdients).size > 1 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
  end

  def calculate_great_drinks
    Drink.all.select do |drink| # 5. calculate User.current_user.s "great_drinks array"
      if (User.current_user.liked_drinks + User.current_user.disliked_drinks).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & User.current_user.liked_ingrdients).size > 1 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & User.current_user.liked_ingrdients).size > 2 && (drink.all_ingredients & User.current_user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
  end

  def return_quiz_results
    User.current_user.quiz_results = [] # 6. return User.current_user.s quiz results
    if (User.current_user.great_drinks & Drink.select_for_test).size > 0
      User.current_user.quiz_results << (User.current_user.great_drinks & Drink.select_for_test).sample
      puts "\n"
      puts "The answer was under our noses the entire time!".center(59).light_blue
      puts "We know we've asked you about this drink in the list above,".light_blue
      puts "but we're totally positive that you would love #{User.current_user.quiz_results[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(59).light_blue
      puts "\n"
      puts "#{User.current_user.quiz_results[-1].strDrink}!".center(59).cyan
      puts "It's made with #{User.current_user.quiz_results[-1].print_ingredients}".center(59).cyan
      puts "\n"
      puts "Give it a whirl, if you haven't tried one before!".center(59).light_blue
      puts "\n"
    elsif User.current_user.great_drinks.size > 0
      User.current_user.quiz_results << User.current_user.great_drinks.sample
      puts "\n"
      puts "So, we had to look into some of our more obsucre".center(61).light_blue
      puts "cocktail recipes to find something just perfect for you".center(61).light_blue
      puts "but we're still totally certain that you're going to love it!".light_blue
      puts "\n"
      puts "The #{User.current_user.quiz_results[-1].strDrink}!".center(61).cyan
      puts "It's made with #{User.current_user.quiz_results[-1].print_ingredients}".center(61).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(61).light_blue
      puts "\n"
    else
      User.current_user.quiz_results << User.current_user.okay_drinks.sample
      puts "\n"
      puts "We have to admit it... you've stumped us a little bit!".center(64).light_blue
      puts "Maybe all drink palates can't be boiled down to some algorithms,".light_blue
      puts "but we're still decently confident that you'd enjoy #{User.current_user.quiz_results[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(64).light_blue
      puts "\n"
      puts "#{User.current_user.quiz_results[-1].strDrink}!".center(64).cyan
      puts "It's made with #{User.current_user.quiz_results[-1].print_ingredients}".center(64).cyan
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
