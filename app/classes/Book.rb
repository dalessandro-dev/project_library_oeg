require_relative 'Library.rb'



class Book < Library
  def createBook
    puts "\nDigite o título do livro: "
    name = gets.chomp.strip.upcase

    puts "\nDigite o nome do autor: "
    author = gets.chomp.strip.upcase

    puts "\nDigite o ano de publicação do livro: "
    publicationYear = gets.chomp.strip
    


    invalidBook "create", name, name, author, publicationYear


    
    puts "\nO livro está disponível? [s/n]"
    available = gets.chomp.strip.downcase



    if available == "s"
      available = true
      
    elsif available == "n"
      available = false
    
    else
      throw :error, "\nerro: Opção não válida!"

    end



    params = {"name" => name, "book_author" => author, "book_publicationYear" => publicationYear, "book_available" => available}



    data = readFile



    conferUserBook "book", data, params



    newId = nextId(data["books"])

    book = {
      id: newId,
      name: name,
      book_author: author,
      book_publicationYear: publicationYear,
      book_available: available
    }

    data["books"] << book



    writeFile(data)



    puts "\nLivro adicionado com sucesso!"

  end









  
  def updateBook
    puts "\nDigite o título ou o ID do livro: "
    search = gets.chomp.strip.upcase
    
    puts "\nDigite o título do livro ou apenas aperte ENTER se não desejar atualizar isso: "
    name = gets.chomp.strip.upcase

    puts "\nDigite o nome do autor do livro ou apenas aperte ENTER se não desejar atualizar isso: "
    author = gets.chomp.strip.upcase

    puts "\nDigite o ano de publicação do livro ou apenas aperte ENTER se não desejar atualizar isso: "
    publicationYear = gets.chomp.strip.upcase
    
    puts "\nDigite 's' se o livro estiver disponível ou 'n' se não, ou apenas aperte ENTER se não desejar atualizar isso: [s/n]"
    available = gets.chomp.strip



    if available.downcase == "s"
      available = true
    
    elsif available.downcase == "n"
      available = false

    elsif available != ""
      throw :error, "\nerro: Opção não válida!"

    end



    invalidBook "update", search, name, author, publicationYear



    params = {"name" => name, "book_author" => author, "book_publicationYear" => publicationYear, "book_available" => available}



    AllEmptyFields params



    data = readFile



    conferUserBook "book", data, params

    
    
    value = data["books"].select { |e| e["name"].start_with?(search) || e["id"] == search.to_i }



    value = outputBookUser "book", value, "atualizar"



    response = gets.chomp.downcase

    if response == "s"    
      if data["loans"].any? { |e| value["id"] == e["book_id"] } && available
        throw :error, "\nerro: Não foi possível atualizar, pois você tentou alterar a disponibilidade enquanto o livro estava emprestado!"

      end



      params.each { |key, valueHash|

      if (valueHash.is_a?(String) && !valueHash.empty?) || valueHash.is_a?(TrueClass) || valueHash.is_a?(FalseClass)
        value[key] = valueHash

      end 
    
      } 



      writeFile(data)


    
      puts "\nLivro atualizado com sucesso!"
    
    else
      puts "\nOperação encerrada!"

    end

  end
  
end