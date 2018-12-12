class Drink
  attr_accessor :idDrink, :strDrink, :all_ingredients, :strIngredient1, :strIngredient2, :strIngredient3, :strIngredient4, :strIngredient5, :strIngredient6, :strIngredient7, :strIngredient8, :strMeasure1, :strMeasure2, :strMeasure3, :strMeasure4, :strMeasure5, :strMeasure6, :strMeasure7, :strMeasure8, :strInstructions

  TEST_DRINKS = ["Boulevardier", "Cosmopolitan", "Dirty Martini", "Espresso Martini", "French Negroni", "Gimlet", "Gin Rickey", "Greyhound", "Lemon Drop", "Manhattan", "Martini", "Mojito", "Old Fashioned", "Pisco Sour", "The Last Word"]


  @@all = []

  # def initialize#(idDrink: "", strDrink: "", strIngredient1: "", strIngredient2: "", strIngredient3: "", strIngredient4: "", strIngredient5: "", strIngredient6: "", strIngredient7: "", strIngredient8: "", strMeasure1: "", strMeasure2: "", strMeasure3: "", strMeasure4: "", strMeasure5: "", strMeasure6: "", strMeasure7: "", strMeasure8: "", strInstructions: "")
  #
  # end

  def self.all
    @@all
  end

  def self.new_from_hash#(hash)
    ::DRINK_HASH.each do |id, drink_array|
      drink = self.new
      drink.all_ingredients = []
      drink_array[0].each do |method, arg| ###REMOVE THIS ZERO WHEN YOU PULL FROM API!!!
        if drink.respond_to?("#{method}") && arg.is_a?(String) && arg.include?("Absolut")
          drink.send("#{method}=", "Vodka") #Had to hardcode this in
          #because for almost every drink they list a generic liquor
          #as an ingredient, except for, frustratingly, certain vodka
          #drinks, for which they give a brand name Absolut variety
          #that messes up my algorithm
        elsif drink.respond_to?("#{method}") && arg != " " && arg != ""
          drink.send("#{method}=", arg)
        end
      end
      drink.instance_variables.map{|v|v.to_s.tr('@', '')}.select{|v| v.match(/^strIng/)}.each do |v|
        drink.all_ingredients << drink.send("#{v}") unless drink.send("#{v}") == nil
      end
      @@all << drink
    end
  end

  def self.select_for_test
    self.all.select {|d| TEST_DRINKS.include?(d.strDrink)}
  end

end
