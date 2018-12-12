class Drink
  attr_accessor :idDrink, :strDrink, :strIngredient1, :strIngredient2, :strIngredient3, :strIngredient4, :strIngredient5, :strIngredient6, :strIngredient7, :strIngredient8, :strMeasure1, :strMeasure2, :strMeasure3, :strMeasure4, :strMeasure5, :strMeasure6, :strMeasure7, :strMeasure8, :strInstructions

  TEST_DRINKS = ["Boulevardier", "Cosmopolitan", "Dirty Martini", "Espresso Martini", "French Negroni", "Gimlet", "Gin Rickey", "Greyhound", "Lemon Drop", "Manhattan", "Martini", "Mojito", "Old Fashioned", "Paloma", "Pisco Sour", "The Last Word"]


  @@all = []

  # def initialize#(idDrink: "", strDrink: "", strIngredient1: "", strIngredient2: "", strIngredient3: "", strIngredient4: "", strIngredient5: "", strIngredient6: "", strIngredient7: "", strIngredient8: "", strMeasure1: "", strMeasure2: "", strMeasure3: "", strMeasure4: "", strMeasure5: "", strMeasure6: "", strMeasure7: "", strMeasure8: "", strInstructions: "")
  #
  # end

  def self.all
    @@all
  end

  def self.new_from_hash(hash)
    hash.each do |id, drink_array|
      drink = self.new
      drink_array.each do |method, arg|
        if drink.respond_to?("#{method}") && arg != " " && arg != ""
          drink.send("#{method}=", arg)
        end
      end
      @@all << drink
    end
  end

  def self.select_for_test
    self.all.select {|d| TEST_DRINKS.include?(d.strDrink)}
  end

end
