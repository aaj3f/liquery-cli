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
    puts <<~EOC

                Welcome to LiquerY

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

    EOC
  end

  def compile
    spinner = ::TTY::Spinner.new("                    [:spinner]", format: :bouncing)
    spinner.auto_spin
    Drink.new_from_hash#(DrinkAPI.new.make_hash)
    spinner.stop('Done!')
  end

  def main_menu
    puts "\n Are you ready to take our quiz? [Press Enter to begin]..."
    STDIN.getch
  end

  def drink_quiz
    puts "\nListed below are some classic coctails. Pick the one you enjoy the most!"
    a = Drink.select_for_test.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your favorite: "
    input = gets.chomp
    drink1 = a[input.to_i - 1]
    puts "\nGotcha! So of the drinks above, your favorite is: #{drink1.strDrink}?"
    puts "\n If you had to pick one other drink from this smaller list,"
    puts "what would it be?"
    b = a.each.with_object([]) do |drink, array|
      drink1.all_ingredients.each do |ingredient|
        array << drink if drink.all_ingredients.include?(ingredient) # && ingredient != "Sugar syrup"
      end
    end.uniq.reject{|d| d == drink1}
    b.each.with_index(1) {|x, i| puts "\t#{i}. #{x.strDrink}"}
    print "Your choice: "
    input = gets.chomp
    drink2 = b[input.to_i - 1]
    puts "\nSuper! So although your 1st choice was: #{drink1.strDrink},"
    puts "you also could find yourself enjoying: #{drink2.strDrink}."

    # a.select{|d| d.}
  end


end


# bar = TTY::ProgressBar.new("[:bar]", total: content_size)
# response = bar.
