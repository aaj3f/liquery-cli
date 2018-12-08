class Drink
  attr_accessor :idDrink, :strDrink, :strIngredient1, :strIngredient2, :strIngredient3, :strIngredient4, :strIngredient5, :strIngredient6, :strIngredient7, :strIngredient8, :strMeasure1, :strMeasure2, :strMeasure3, :strMeasure4, :strMeasure5, :strMeasure6, :strMeasure7, :strMeasure8, :strInstructions

  @@all = []

  def self.all
    @@all
  end

  def self.new_from_hash
    DRINK_HASH.each do |id, drink_array|
      drink = self.new
      drink_array[0].each do |method, arg|
        if drink.respond_to?("#{method}")
          drink.send("#{method}=", arg)
        end
      end
      @@all << drink
    end
  end

end
