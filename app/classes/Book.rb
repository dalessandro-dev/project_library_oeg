require_relative 'Library.rb'



class Book < Library

  def createBook(title, author, publicationYear, available)
    data = readFile

    newId = nextId(data["books"])

    title = title.strip.upcase

    author = author.strip.upcase

    publicationYear = publicationYear.strip.upcase



    if title.empty? || author.empty? || publicationYear.empty?
      puts "Algum campo não foi preenchido!"
      
      return
    end 

    if !publicationYear.match?(/\A-?\d+\z/) || publicationYear.strip.to_i > Time.now.year
      puts "Data de publicação do livro inválida!"
        
      return

    end

    data["books"].each { |e|

    if e["name"] == title && e["book_author"] == author && e["book_publicationYear"] == publicationYear 
      puts "Esse livro já foi cadastrado!"



      return

    end }



    book = {
      id: newId,
      name: title,
      book_author: author,
      book_publicationYear: publicationYear,
      book_available: available
    }

    data["books"] << book



    writeFile(data)



    puts "Livro adicionado com sucesso!"

  end





  def updateBook obj, name = "", author = "", publicationYear = "", available = ""
    if !available.is_a?(TrueClass) && !available.is_a?(FalseClass)
      available = available.strip

    end

    params = {"name" => name.upcase.strip, "book_author" => author.upcase.strip, "book_publicationYear" => publicationYear.strip, "book_available" => available}

    data = readFile



    if !params.any? { |key, value| !value.empty?}
      puts "Nenhum campo foi preenchido!"

      return
      
    end

    if !publicationYear.empty? && !publicationYear.match?(/\A-?\d+\z/) || publicationYear.strip.to_i > Time.now.year
      puts "Data de publicação do livro inválida!"
      


      return

    end

    if !name.empty?
      data["books"].each { |e|
      
      if e["name"] == params["name"] && e["book_author"] == params["book_author"] && params["book_publicationYear"] == publicationYear 
        puts "Esse livro já foi cadastrado!"
  


        return

      end }

    end


    
    if obj.match?(/^[1-9]\d*$/)
      value = data["books"].find { |e| e["id"] == obj.to_i }

    elsif !obj.match?(/^[1-9]\d*$/) && !obj.empty?
      value = data["books"].find { |e| e["name"].start_with?(obj.upcase) }

    else
      puts "Tipo de entrada não permitida!"
      


      return

    end



    if value.nil?
      puts "Livro não encontrado!"



      return

    end



    if value["book_available"]
      availableBook = "Disponível"

    else
      availableBook = "Indisponível"

    end  
    


    msg = <<~MSG
    =====================================================================
    ID: #{value["id"]}
    Título: #{value["name"]}
    Autor: #{value["book_author"]}
    Ano de publicação: #{value["book_publicationYear"]}
    Disponibilidade: #{availableBook}
    =====================================================================
    Tem certeza que deseja atualizar o livro exibido? [s/n]
    MSG



    puts msg
    response = gets.chomp

    if response.downcase == "s"
      params.each { |key, valueHash|
      if (valueHash.is_a?(String) && !valueHash.empty?) || valueHash.is_a?(TrueClass) || valueHash.is_a?(FalseClass)

        value[key] = valueHash

      end } 


      
      writeFile(data)


    
      puts "Livro atualizado com sucesso!"
    
    else
      puts "Operação encerrada!"



      return

    end

  end
  
end