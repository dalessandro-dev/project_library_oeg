require_relative 'app/classes/User.rb'

require_relative 'app/classes/Book.rb'

require_relative 'app/classes/Library.rb'



user = User.new

book = Book.new

library = Library.new



library.main book, user