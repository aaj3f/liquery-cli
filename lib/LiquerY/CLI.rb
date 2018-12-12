class LiquerY::CLI

  def call
    welcome
    compile
    main_menu

  end

  def welcome
    puts "\nWelcome to LiquerY!"
    puts <<~EOC
    Liquery is a games-style CLI app that attempts to
    help its users better understand what they enjoy
    in cocktails & drinks, so that in the process,
    they'll learn new & exciting drinks that they're
    statistically much more likely to enjoy!

    Please wait as we compile our database of cocktails
    and user preferences!
    EOC
  end

  def compile
    Drink.new_from_hash(DrinkAPI.new.make_hash)
  end

  def main_menu
    puts "This is the main menu"
    pp (Drink.select_for_test.map {|d| d.strDrink})
  end


end
