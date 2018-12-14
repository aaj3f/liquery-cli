class User
  attr_accessor :liked_drinks, :liked_ingrdients, :disliked_drinks, :quiz_results, :okay_drinks, :great_drinks

  @@all = []

  def initialize
    self.liked_drinks = []
    self.liked_ingrdients = []
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
    "Drinks you like: #{self.names(liked_drinks)}#{"& Drinks we've recommended: #{self.names(quiz_results)}" if self.quiz_results}."
  end

  def list_disliked_drinks
    "Drinks you dislike: #{self.names(disliked_drinks)}."
  end

  def names(drink_array)
    self.send("#{drink_array}").map {|drink| drink.strDrink}
  end

  def recent_choice
    self.liked_drinks[-1]
  end

  def add_to_liked_ingredients
    @liked_ingrdients.concat((self.liked_drinks.map {|d| d.all_ingredients}).flatten.uniq)
  end

end
