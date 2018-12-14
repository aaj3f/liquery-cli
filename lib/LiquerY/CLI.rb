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
    user = User.new
    puts "\nListed below are some classic coctails. Pick the one you enjoy the most!".cyan
    a = Drink.select_for_test.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your favorite: ".cyan
    input = gets.chomp
    user.liked_drinks << a[input.to_i - 1]
    puts "\nGotcha! So of the drinks above, your favorite is #{user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{user.recent_choice.strDrink}?".light_blue
    puts "\nIf you had to pick one other drink from this smaller list,".cyan
    puts "what would it be?".cyan
    b = a.each.with_object([]) do |drink, array|
      user.recent_choice.all_ingredients.each do |ingredient|
        array << drink if drink.all_ingredients.include?(ingredient) # && ingredient != "Sugar syrup"
      end
    end.uniq.reject{|d| d == user.recent_choice}
    b.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your choice: ".cyan
    input = gets.chomp
    user.liked_drinks << b[input.to_i - 1]
    puts "\nSuper! So although your 1st choice was #{user.liked_drinks[-2].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{user.liked_drinks[-2].strDrink},".light_blue
    puts "you also could find yourself enjoying #{user.recent_choice.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{user.recent_choice.strDrink}.".light_blue
    puts "\nJust a few more questions! [Press Enter to continue]..."
    STDIN.getch
    puts "\nGiven the cocktails you've identified so far, we're noticing".cyan
    puts "that you might not enjoy the palates of some of these drinks:".cyan
    good_ingredients = (user.liked_drinks.map {|d| d.all_ingredients}).flatten.uniq
    bad_drinks = a.select do |drink|
      (drink.all_ingredients & good_ingredients).empty?
    end
    bad_drinks.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    puts "Is there one drink on this list that you absolutely cannot stand?".cyan
    print "Your choice: ".cyan
    input = gets.chomp
    user.disliked_drinks << bad_drinks[input.to_i - 1]
    puts "\nBlech! You just do not enjoy #{user.disliked_drinks[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{user.disliked_drinks[-1].strDrink}.".light_blue
    puts "We hear you! And that's great to know!".light_blue
    okay_drinks = Drink.all.select do |drink|
      if (user.liked_drinks + user.disliked_drinks).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & good_ingredients).size > 0 && (drink.all_ingredients & user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & good_ingredients).size > 1 && (drink.all_ingredients & user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
    great_drinks = Drink.all.select do |drink|
      if (user.liked_drinks + user.disliked_drinks).include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & good_ingredients).size > 1 && (drink.all_ingredients & user.disliked_drinks[-1].all_ingredients).size <= 1
      else
        (drink.all_ingredients & good_ingredients).size > 2 && (drink.all_ingredients & user.disliked_drinks[-1].all_ingredients).size <= 1
      end
    end
    puts "\nThanks for completing our quiz!! Now give us just one second as"
    puts "we find a drink you're sure to enjoy! [Press Enter to Continue...]"
    STDIN.getch
    user.quiz_results = []
    if (great_drinks & a).size > 0
      user.quiz_results << (great_drinks & a).sample
      puts "\n"
      puts "The answer was under our noses the entire time!".center(59).light_blue
      puts "We know we've asked you about this drink in the list above,".light_blue
      puts "but we're totally positive that you would love #{user.quiz_results[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(59).light_blue
      puts "\n"
      puts "#{user.quiz_results[-1].strDrink}!".center(59).cyan
      puts "It's made with #{user.quiz_results[-1].print_ingredients}".center(59).cyan
      puts "\n"
      puts "Give it a whirl, if you haven't tried one before!".center(59).light_blue
      puts "\n"
    elsif great_drinks.size > 0
      user.quiz_results << great_drinks.sample
      puts "\n"
      puts "So, we had to look into some of our more obsucre".center(61).light_blue
      puts "cocktail recipes to find something just perfect for you".center(61).light_blue
      puts "but we're still totally certain that you're going to love it!".light_blue
      puts "\n"
      puts "The #{user.quiz_results[-1].strDrink}!".center(61).cyan
      puts "It's made with #{user.quiz_results[-1].print_ingredients}".center(61).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(61).light_blue
      puts "\n"
    else
      user.quiz_results << okay_drinks.sample
      puts "\n"
      puts "We have to admit it... you've stumped us a little bit!".center(64).light_blue
      puts "Maybe all drink palates can't be boiled down to some algorithms,".light_blue
      puts "but we're still decently confident that you'd enjoy #{user.quiz_results[-1].strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(64).light_blue
      puts "\n"
      puts "#{user.quiz_results[-1].strDrink}!".center(64).cyan
      puts "It's made with #{user.quiz_results[-1].print_ingredients}".center(64).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(64).light_blue
      puts "\n"
    end
    # good_drinks.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
  end


end
