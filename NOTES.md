


Need to make:
  User class
    that can:
      instantiate individual users -- X
        that can:
          save desired and undesired drinks as instance variables -- X
          save the quiz recommendation as an instance variable
      remember all users as class variable
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
