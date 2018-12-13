class User
  attr_accessor :liked_drinks, :disliked_drinks, :quiz_results

  @@all = []

  def initialize
    self.liked_drinks = []
    self.disliked_drinks = []
    @@all << self
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

end
