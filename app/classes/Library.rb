require "json"

class Library
  
  def initialize
    @json_file = File.join(__dir__, '..', 'data', 'data.json')
  end

  



  def createLoan userParam, bookParam
    data = readFile

    userParam = userParam.strip

    bookParam = bookParam.strip



    if !userParam.match?(/^[1-9]\d*$/)
      user = data["users"].find { |e| e["name"].start_with?(userParam.upcase) }

    elsif userParam.match?(/^[1-9]\d*$/)
      user = data["users"].find { |e| e["id"] == userParam.to_i }

    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return

    end


  
    if user.nil?
      puts "Usuário não encontrado! Tente novamente."
      


      return

    end



    if !bookParam.match?(/^[1-9]\d*$/)
      book = data["books"].find { |e| e["name"].start_with?(bookParam.upcase) }

    elsif bookParam.match?(/^[1-9]\d*$/)
      book = data["books"].find { |e| e["id"] == bookParam.to_i }
      
    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return

    end



    if book.nil?
      puts "Livro não encontrado! Tente novamente."
    
      
      
      return
    
    end



    if !book["book_available"]
      puts "Livro indisponível! Tente novamente."



      return

    end



    loan = {"book_id" => book["id"], "user_id" => user["id"]}

    data["loans"] << loan

    book["book_available"] = false



    writeFile(data)


    
    puts "Empréstimo feito com sucesso!"

  end





  def undoLoan book
    data = readFile
    
    book = book.strip


    
    if book.match?(/^[1-9]\d*$/)
      book = data["books"].find { |e| e["id"] == book.to_i}

    elsif !book.match?(/^[1-9]\d*$/)
      book = data["books"].find { |e| e["name"].start_with?(book.upcase)}
    
    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return
    
    end



    if book.nil?
      puts "Livro não encontrado! Tente novamente."



      return
     
    end



    if !data["loans"].any? { |e| e["book_id"] == book["id"] }
      puts "Livro não emprestado! Tente novamente."



      return
    
    end 



    data["loans"] = data["loans"].reject! {|e| e["book_id"] == book["id"]}

    book["book_available"] = true



    writeFile(data)



    puts "Devolução feita com sucesso!"

  end





  def findBookOrUser obj, value
    data = readFile

    value = value.strip
    
    msg = ""



    if !value.match?(/^[1-9]\d*$/)
      if obj == "user"
        values = data["users"].select {|e| e["name"].start_with?(value.upcase)}

      elsif obj == "book"
        values = data["books"].select {|e| e["name"].start_with?(value.upcase)}

      else
        puts "Campo não identificado! Tente novamente."



        return
      
      end
      
    elsif value.match?(/^[1-9]\d*$/)
      if obj == "user"
        values = data["users"].select { |e| e["id"] == value.to_i }

      elsif obj == "book"
        values = data["books"].select { |e| e["id"] == value.to_i }

      else
        puts "Campo não identificado! Tente novamente."



        return

      end
    
    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return

    end


    
    if values.empty?
      puts "Livro(s) ou usuário(s) não encontrado(s)!"



      return

    end


    if obj == "user"
      values.each { |e| 

      msg += <<~MSG
      =====================================================================
      ID: #{e["id"]}
      Nome: #{e["name"]}
      E-mail: #{e["user_email"]}
      =====================================================================
      MSG
      }

    else
      values.each { |e|

      if e["book_available"]
        availableBook = "Disponível"

      else
        availableBook = "Indisponível"

      end



      msg += <<~MSG
      =====================================================================
      ID: #{e["id"]}
      Título: #{e["name"]}
      Autor: #{e["book_author"]}
      Ano de publicação: #{e["book_publicationYear"]}
      Disponibilidade: #{availableBook}
      =====================================================================
      MSG
      }

    end



    puts msg

  end





  def delete obj, value
    data = readFile
    
    value = value.strip



    if value.match?(/^[1-9]\d*$/)
      
      if obj == "user"
        value = data["users"].find {|e| e["id"] == value.to_i}
    
      elsif obj == "book"
        value = data["books"].find {|e| e["id"] == value.to_i}
    
      else
        puts "Campo não identificado! Tente novamente."



        return
      
      end

    elsif !value.match?(/^[1-9]\d*$/)

      if obj == "user"
        value = data["users"].find {|e| e["name"].start_with?(value.upcase)}
      
      elsif obj == "book"
        value = data["books"].find {|e| e["name"].start_with?(value.upcase)}
      
      else
        puts "Campo não identificado! Tente novamente."



        return
      
      end

    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return
    
    end



    if value.nil?
      puts "Livro ou usuário não encontrado! Tente novamente."



      return
    
    end



    if obj == "book"
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
      Tem certeza que deseja deletar o livro exibido? [s/n]
      MSG

    else
      msg += <<~MSG
      =====================================================================
      ID: #{e["id"]}
      Nome: #{e["name"]}
      E-mail: #{e["user_email"]}
      =====================================================================
      Tem certeza que deseja deletar o usuário exibido? [s/n]
      MSG
    
    end



    puts msg
    response = gets.chomp

    if response.downcase == "s"

      if obj == "user" 
        data["users"].reject! { |e| e == value }

      else
        data["books"].reject! { |e| e == value }

      end



      writeFile(data)



      puts "Livro ou usuário deletado com sucesso!"
    
    else
      puts "Operação encerrada!"
      


      return
    
    end

  end





  private

  def readFile
    JSON.parse(File.read(@json_file))

  end



  def writeFile(data)
    File.write(@json_file, JSON.pretty_generate(data))

  end



  def nextId(array)
    return 1 if array.empty?

    array.max_by{|e| e["id"]}["id"] + 1

  end
  
end
