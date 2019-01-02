class DrinkAPI
  attr_reader :id_array
  def initialize
    data = open("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail").read
    doc = JSON.parse(data)
    #key is ["drinks"] value is array of ingredients
    @id_array = doc.first.last.each.with_object([]) do |id_hash, array|
      array << id_hash["idDrink"]
    end
  end

  def make_hash
    self.id_array.each.with_object({}) do |id, drink_hash|
      drink_hash[id] = JSON.parse(open("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{id}").read).values.first[0]
    end
  end
end
