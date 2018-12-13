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
    spinner = ::TTY::Spinner.new("                    [:spinner]".light_blue, format: :bouncing)
    spinner.auto_spin
    Drink.new_from_hash(DrinkAPI.new.make_hash)
    spinner.stop('Done!'.light_blue)
  end

  def main_menu
    puts "\nAre you ready to take our quiz? [Press Enter to begin]..."
    STDIN.getch
  end

  def drink_quiz
    puts "\nListed below are some classic coctails. Pick the one you enjoy the most!".cyan
    a = Drink.select_for_test.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your favorite: ".cyan
    input = gets.chomp
    drink1 = a[input.to_i - 1]
    puts "\nGotcha! So of the drinks above, your favorite is #{drink1.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{drink1.strDrink}?".light_blue
    puts "\nIf you had to pick one other drink from this smaller list,".cyan
    puts "what would it be?".cyan
    b = a.each.with_object([]) do |drink, array|
      drink1.all_ingredients.each do |ingredient|
        array << drink if drink.all_ingredients.include?(ingredient) # && ingredient != "Sugar syrup"
      end
    end.uniq.reject{|d| d == drink1}
    b.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your choice: ".cyan
    input = gets.chomp
    drink2 = b[input.to_i - 1]
    puts "\nSuper! So although your 1st choice was #{drink1.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{drink1.strDrink},".light_blue
    puts "you also could find yourself enjoying #{drink2.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{drink2.strDrink}.".light_blue
    puts "\nJust a few more questions! [Press Enter to continue]..."
    STDIN.getch
    puts "\nGiven the cocktails you've identified so far, we're noticing".cyan
    puts "that you might not enjoy the palates of some of these drinks:".cyan
    good_ingredients = (drink1.all_ingredients + drink2.all_ingredients).flatten.uniq
    bad_drinks = a.select do |drink|
      (drink.all_ingredients & good_ingredients).empty?
    end
    bad_drinks.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    puts "Is there one drink on this list that you absolutely cannot stand?".cyan
    print "Your choice: ".cyan
    input = gets.chomp
    drink3 = bad_drinks[input.to_i - 1]
    puts "\nBlech! You just do not enjoy #{drink3.strDrink.match(/^[aeiou]/i) ? "an" : "a"} #{drink3.strDrink}.".light_blue
    puts "We hear you! And that's great to know!".light_blue
    okay_drinks = Drink.all.select do |drink|
      if [drink1, drink2, drink3].include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & good_ingredients).size > 0 && (drink.all_ingredients & drink3.all_ingredients).size <= 1
      else
        (drink.all_ingredients & good_ingredients).size > 1 && (drink.all_ingredients & drink3.all_ingredients).size <= 1
      end
    end
    great_drinks = Drink.all.select do |drink|
      if [drink1, drink2, drink3].include?(drink)
        false
      elsif drink.all_ingredients.size < 4
        (drink.all_ingredients & good_ingredients).size > 1 && (drink.all_ingredients & drink3.all_ingredients).size <= 1
      else
        (drink.all_ingredients & good_ingredients).size > 2 && (drink.all_ingredients & drink3.all_ingredients).size <= 1
      end
    end
    puts "\nThanks for completing our quiz!! Now give us just one second as"
    puts "we find a drink you're sure to enjoy! [Press Enter to Continue...]"
    STDIN.getch
    sample = ""
    if (great_drinks & a).size > 0
      sample = (great_drinks & a).sample
      puts "\n"
      puts "The answer was under our noses the entire time!".center(59).light_blue
      puts "We know we've asked you about this drink in the list above,".light_blue
      puts "but we're totally positive that you would love #{sample.strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(59).light_blue
      puts "\n"
      puts "#{sample.strDrink}!".center(59).cyan
      puts "It's made with #{sample.print_ingredients}".center(59).cyan
      puts "\n"
      puts "Give it a whirl, if you haven't tried one before!".center(59).light_blue
      puts "\n"
    elsif great_drinks.size > 0
      sample = great_drinks.sample
      puts "\n"
      puts "So, we had to look into some of our more obsucre".center(61).light_blue
      puts "cocktail recipes to find something just perfect for you".center(61).light_blue
      puts "but we're still totally certain that you're going to love it!".light_blue
      puts "\n"
      puts "The #{sample.strDrink}!".center(61).cyan
      puts "It's made with #{sample.print_ingredients}".center(59).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(61).light_blue
      puts "\n"
    else
      sample = okay_drinks.sample
      puts "\n"
      puts "We have to admit it... you've stumped us a little bit!".center(64).light_blue
      puts "Maybe all drink palates can't be boiled down to some algorithms,".light_blue
      puts "but we're still decently confident that you'd enjoy #{sample.strDrink.match(/^[aeiou]/i) ? "an" : "a"}".center(64).light_blue
      puts "\n"
      puts "#{sample.strDrink}!".center(64).cyan
      puts "It's made with #{sample.print_ingredients}".center(59).cyan
      puts "\n"
      puts "Be sure to give it a taste!".center(64).light_blue
      puts "\n"
    end
    # good_drinks.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
  end


end
