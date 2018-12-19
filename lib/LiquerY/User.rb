class User
  attr_accessor :liked_drinks, :liked_ingredients, :disliked_drinks, :quiz_results, :okay_drinks, :great_drinks

  @@all = []

  def initialize
    self.liked_drinks = []
    self.liked_ingredients = []
    self.disliked_drinks = []
    @@all << self
  end

  def self.all
    @@all
  end

  def self.current_user
    @@all[-1]
  end

  def list_liked_drinks
    puts "Drinks you like:".cyan
    puts "\n\t#{self.print_list(self.liked_drinks.uniq)}".light_blue
    puts "\nDrinks we've recommended:".cyan
    puts "\n\t#{self.print_list(self.quiz_results)}".light_blue
  end

  def list_disliked_drinks
    "Drinks you dislike: #{self.names(disliked_drinks)}."
  end

  def print_list(array)
    array.each.with_object("") do |drink, string|
      if array.size == 1
        string << drink.strDrink
      elsif array.size == 2 && drink == array[0]
        string << "#{drink.strDrink} "
      elsif drink == array[-1]
        string << "and #{drink.strDrink}"
      else
        string << "#{drink.strDrink}, "
      end
    end
  end

  def names(drink_array)
    drink_array.map {|drink| drink.strDrink}
  end

  def recent_choice
    self.liked_drinks[-1]
  end

  def add_to_liked_ingredients
    @liked_ingredients.concat((self.liked_drinks.map {|d| d.all_ingredients}).flatten.uniq)
  end

end
