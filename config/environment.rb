require 'bundler'
Bundler.require

require_relative "../lib/LiquerY/CLI"
require_relative "../lib/LiquerY/database"
require_relative "../lib/LiquerY/drink"
require_relative "../lib/LiquerY/DrinkAPI"
require_relative "../lib/LiquerY/User"
require_relative "../lib/LiquerY/version"

require 'open-uri'
require 'io/console'
require 'colorize'
require 'colorized_string'
require 'fuzzy_match'

module LiquerY
  class Error < StandardError; end
  # Your code goes here...
end
