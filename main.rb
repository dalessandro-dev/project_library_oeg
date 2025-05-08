require_relative 'app/classes/User.rb'

require_relative 'app/classes/Book.rb'



user = User.new

book = Book.new

loop = true



while loop
  
  message = <<~MSG
  ========================================
  Bem-vindo à Biblioteca OEG!
  Onde o conhecimento ganha vida!
  ========================================

  1. Adicionar um usuário ou um livro
  2. Procurar um usuário ou um livro
  3. Atualizar um usuário ou um livro
  4. Deletar um usuário ou um livro
  5. Fazer o empréstimo de um livro
  6. Fazer a devolução de um livro
  7. Sair

  Digite uma opção para começar...
  MSG



  puts message
  option = gets.chomp

  if option == "1"
    puts "Deseja adicionar um livro (1) ou usuário (2)? [1/2]"
    response = gets.chomp

    

    if response == "1"
      puts "Digite o título do livro: "
      title = gets.chomp

      puts "Digite o nome do autor: "
      author = gets.chomp

      puts "Digite o ano de publicação do livro: "
      publicationYear = gets.chomp

      puts "O livro está disponível? [s/n]"
      available = gets.chomp

      if available.downcase == "s"
        available = true

        book.createBook(title, author, publicationYear, available)
        
      elsif available.downcase == "n"
        available = false

        book.createBook(title, author, publicationYear, available)
      
      else
        puts "Opção não válida! Tente novamente."

      end

    elsif response == "2"
      puts "Digite o nome do usuário: "
      name = gets.chomp

      puts "Digite o e-mail do usuário: "
      email = gets.chomp



      user.createUser(name, email)
    
    else
      puts "Opção não válida! Tente novamente."

    end

  elsif option == "2"
    puts "Deseja procurar um livro (1) ou usuário (2)? [1/2]"
    response = gets.chomp

    if response == "1"
      puts "Digite o título ou o ID do livro: "
      value = gets.chomp



      book.findBookOrUser("book", value)

    elsif response == "2"
      puts "Digite o nome ou o ID do usuário: "
      value = gets.chomp



      user.findBookOrUser("user", value)
    
    else
      puts "Opção não válida! Tente novamente."

    end

  elsif option == "3"
    puts "Deseja atualizar um livro (1) ou usuário (2)? [1/2]"
    response = gets.chomp

    if response == "1"
      params = ["", "", "", "", ""]



      puts "Digite o título ou o ID do livro: "
      params[0] = gets.chomp
      
      puts "Digite o título do livro ou apenas aperte ENTER se não desejar atualizar isso: "
      params[1] = gets.chomp

      puts "Digite o nome do autor do livro ou apenas aperte ENTER se não desejar atualizar isso: "
      params[2] = gets.chomp

      puts "Digite o ano de publicação do livro ou apenas aperte ENTER se não desejar atualizar isso: "
      params[3] = gets.chomp

      puts "Digite 's' se o livro estiver disponível ou 'n' se não, ou apenas aperte ENTER se não desejar atualizar isso: [s/n]"
      option = gets.chomp
      
      if option.downcase == "s"
        params[4] = true



        book.updateBook(*params)
      
      elsif option.downcase == "n"
        params[4] = false



        book.updateBook(*params)

      elsif option.empty?
        book.updateBook(*params)

      else
        puts "Opção não válida! Tente novamente."

      end
    
    elsif response == "2"
      params = ["", "", ""]



      puts "Digite o nome ou o ID do usuário: "
      params[0] = gets.chomp
        
      puts "Digite o nome do usuário ou apenas aperte ENTER se não desejar atualizar isso: "
      params[1] = gets.chomp
    
      puts "Digite o e-mail do usuário ou apenas aperte ENTER se não desejar atualizar isso: "
      params[2] = gets.chomp



      user.updateUser(*params)
    
    else
        puts "Opção não válida! Tente novamente."

    end

  elsif option == "4"
    puts "Deseja deletar um livro (1) ou um usuário (2)? [1/2]"
    response = gets.chomp

    

    if response == "1"
      puts "Digite o nome ou o ID do livro: "
      value = gets.chomp



      book.delete("book", value)

    elsif response == "2"
      puts "Digite o nome ou o ID do usuário: "
      value = gets.chomp



      user.delete("user", value)

    else
      puts "Opção não válida! Tente novamente."

    end

  elsif option == "5"
    puts "Digite o título ou o ID do livro que será emprestado: "
    bookLoan = gets.chomp



    puts "Digite o nome ou o ID do usuário que receberá o livro: "
    user = gets.chomp

    
    
    book.createLoan(user, bookLoan)

  elsif option == "6"
    puts "Digite o título ou o ID do livro que será feito a devolução: "
    bookLoan = gets.chomp

    

    book.undoLoan(bookLoan)

  elsif option == "7"
    puts "Saindo..."



    break
  
  else
    puts "Opção não válida! Tente novamente."
  
  end



  puts "Deseja continuar? [s/n]"
  response = gets.chomp

  if response.downcase == "s"
    next

  else
    break

  end

end
