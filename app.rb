# lignes très pratiques qui appellent les gems du Gemfile. On verra plus tard comment s'en servir ;) - ça évite juste les "require" partout
require 'bundler'
#require 'pry'
Bundler.require


# lignes qui appellent les fichiers lib/user.rb et lib/event.rb
# comme ça, tu peux faire User.new dans ce fichier d'application. Top.
require_relative 'lib/app/scrappeur'

site = Email.new

#site.save_as_JSON
site.save_as_csv
#site.save_as_spreadsheet
#puts "dffdf"


