class Drink
  attr_accessor :idDrink, :strDrink, :all_ingredients, :strIngredient1, :strIngredient2, :strIngredient3, :strIngredient4, :strIngredient5, :strIngredient6, :strIngredient7, :strIngredient8, :strIngredient9, :strMeasure1, :strMeasure2, :strMeasure3, :strMeasure4, :strMeasure5, :strMeasure6, :strMeasure7, :strMeasure8, :strInstructions, :palate

  TEST_DRINKS = ["Boulevardier", "Cosmopolitan", "Dirty Martini", "Espresso Martini", "French Negroni", "Gimlet", "Gin Rickey", "Greyhound", "Lemon Drop", "Manhattan", "Martini", "Mojito", "Old Fashioned", "Pisco Sour", "The Last Word"]
  DUMMY_DRINK = Drink.new.tap {|d| d.all_ingredients = ["a single bogus and insane ingredient that won't match anything"]}

  @@all = []

  def self.all
    @@all
  end

  def self.new_from_hash#(hash)
    DRINK_HASH.each do |id, drink_array|
      drink = self.new
      drink.all_ingredients = []
      drink_array[0].each do |method, arg| ###REMOVE THIS ZERO WHEN YOU PULL FROM API!!!
        if !(["strDrink", "strInstructions"].include?(method))
          if drink.respond_to?("#{method}") && arg.is_a?(String) && arg.include?("Absolut")
            drink.send("#{method}=", "Vodka") #Had to hardcode this in
            #because for almost every drink they list a generic liquor
            #as an ingredient, except for, frustratingly, certain vodka
            #drinks, for which they give a brand name Absolut variety
            #that messes up my algorithm
          elsif drink.respond_to?("#{method}") && arg.is_a?(String) && (arg.include?("lemon") || arg.include?("Lemon"))
            drink.send("#{method}=", "Lemon Juice")
            drink.send("strIngredient9=", "Simple Syrup")
          elsif drink.respond_to?("#{method}") && arg.is_a?(String) && (arg.include?("Sugar") || arg.include?("Simple"))
            drink.send("#{method}=", "Simple Syrup")
          elsif drink.respond_to?("#{method}") && arg.is_a?(String) && arg.include?("Lime")
            drink.send("#{method}=", "Lime Juice")
          elsif drink.respond_to?("#{method}") && arg != " " && arg != ""
            drink.send("#{method}=", arg)
          end
        elsif drink.respond_to?("#{method}") && arg != " " && arg != ""
          drink.send("#{method}=", arg)
        end
      end
      drink.instance_variables.map{|v|v.to_s.tr('@', '')}.select{|v| v.match(/^strIng/)}.each do |v|
        drink.all_ingredients << drink.send("#{v}") unless (drink.send("#{v}") == nil || drink.all_ingredients.include?(drink.send("#{v}")))
      end
      if (drink.all_ingredients.map {|d|d.downcase} & ["cream", "milk", "kahlua", "bailey", "bailey\'s irish cream", "creme de cacao", "white creme de menthe", "hot chocolate", "coffee liqueur", "chocolate liqueur", "pina colada mix"]).any?
        drink.palate = "creamy"
      elsif (drink.all_ingredients.map {|d|d.downcase} & ["lime juice", "lemon juice"]).any? && !(drink.all_ingredients.map {|d|d.downcase}.include?("simple syrup")) || (drink.all_ingredients.map {|d|d.downcase} & ["sour mix", "sweet and sour", "pisco"]).any?
          drink.palate = "bright"
      elsif (drink.all_ingredients.map {|d|d.downcase} & ["simple syrup", "grenadine", "creme de cassis", "apple juice", "cranberry juice", "pineapple juice", "maraschino cherry", "maraschino liqueur", "grape soda", "kool-aid"]).any?
        drink.palate = "sweet"
      else
        drink.palate = "dry"
      end
      @@all << drink unless drink.idDrink == "14133" #To filter out "Cosmopolitan Martini, which for some reason is included in the database twice under different spellings."
    end
  end

  def self.select_for_test
    self.all.select {|d| TEST_DRINKS.include?(d.strDrink)}
  end

  def print_ingredients
    self.all_ingredients.each.with_object("") do |ing, string|
      if ing == self.all_ingredients[-1]
        string << "and #{ing}."
      else
        string << "#{ing}, "
      end
    end
  end

  def self.search_by_drink_name(name)
    name_match = FuzzyMatch.new(Drink.all.map{|d| d.strDrink}).find("#{name}")
    if Drink.all.find {|d| d.strDrink == name}
      Drink.all.find {|d| d.strDrink == name}
    elsif name_match
      Drink.all.find {|d| d.strDrink == name_match }
    end
  end

  def self.search_by_alcohol_name(name)
    name_match = FuzzyMatch.new(Drink.all.map{|d| d.all_ingredients}.flatten).find("#{name}")
    if Drink.all.map {|d| d.all_ingredients}.flatten.include?(name)
      Drink.all.select {|d| d.all_ingredients.include?(name)}
    elsif name_match
      Drink.all.select {|d| d.all_ingredients.include?(name_match)}
    end
  end

  def self.find_ingredients_by_drink_name(name)
    drink = self.search_by_drink_name(name)
    system "clear"
    puts "Drink Ingredients:".light_blue
    puts "\n#{drink.strDrink} --".cyan
    puts "#{drink.print_ingredients}".cyan
    puts "\n--------------------------------------".light_blue
    puts "\nPress [Enter] to return to the main menu..."
    STDIN.getch
  end

  def self.find_recipe_by_drink_name(name)
    drink = self.search_by_drink_name(name)
    system "clear"
    puts "Drink Recipe:".light_blue
    puts "\n#{drink.strDrink} --".cyan
    puts "Ingredients: ".cyan + "#{drink.print_ingredients}".light_blue
    puts "#{drink.strInstructions}".cyan
    puts "\n--------------------------------------".light_blue
    puts "\nPress [Enter] to return to the main menu..."
    STDIN.getch
  end

  def self.search_by_palate(palate)
    Drink.all.select {|d| d.palate == palate}
  end


end
