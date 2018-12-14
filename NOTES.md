


Need to make:
  
  Flavor Profile class:
    that can:
      instantiate individual flavor profiles
        that can:
          "have-many" drinks and "belong-to" drinks
          "belong-to" users, who will "have-many" flavor profiles


Need to modify:
  Drink class
    so that it can:
      be searchable by drink name
      list drinks by alcohol
      list drinks by flavor profiles
  CLI class
    so that it can:
      call individual methods within the quiz, rather than run through a huge block of code
