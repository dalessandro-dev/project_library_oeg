require "json"

class Library
  
  def initialize
    @json_file = File.join(__dir__, '..', 'data', 'data.json')
  end










  def main book, user
    message = <<~MSG
    ========================================
          Bem-vindo à Biblioteca OEG!
        Onde o conhecimento ganha vida!
    ========================================
    MSG

    puts message


    loop = true

    catch :exit_loop do
      while loop    
        message = <<~MSG

          ========================================

          1. Adicionar um usuário ou um livro
          2. Procurar um usuário ou um livro
          3. Atualizar um usuário ou um livro
          4. Deletar um usuário ou um livro
          5. Fazer o empréstimo de um livro
          6. Fazer a devolução de um livro
          7. Sair

          ========================================

          Digite uma opção para começar...
        MSG



        puts message
        option = gets.chomp



        msgError = catch :error do
          if option == "1"
            puts "\nDeseja adicionar um livro (1) ou usuário (2)? [1/2]"
            response = gets.chomp

            

            if response == "1"
              book.createBook

            elsif response == "2"
              user.createUser
            
            else
              throw :error, "\nerro: Opção inválida!"

            end

          elsif option == "2"
            puts "\nDeseja procurar um livro (1) ou usuário (2)? [1/2]"
            response = gets.chomp



            if response == "1"
              findBookOrUser "book"

            elsif response == "2"
              findBookOrUser "user"
            
            else
              throw :error, "\nerro: Opção inválida!"

            end

          elsif option == "3"
            puts "\nDeseja atualizar um livro (1) ou usuário (2)? [1/2]"
            response = gets.chomp


            
            if response == "1"
              book.updateBook

            elsif response == "2"
              user.updateUser
            
            else
                throw :error, "\nerro: Opção inválida!"

            end

          elsif option == "4"
            puts "\nDeseja deletar um livro (1) ou um usuário (2)? [1/2]"
            response = gets.chomp

            

            if response == "1"
              delete "book"

            elsif response == "2"
              delete "user"

            else
              throw :error, "\nerro: Opção inválida!"

            end

          elsif option == "5" 
            createLoan

          elsif option == "6"
            undoLoan

          elsif option == "7"
            puts "\nSaindo..."



            throw :exit_loop
          
          else
            throw :error, "\nerro: Opção inválida!"
          
          end
        
        end

        puts msgError



        puts "\nDeseja continuar? [s/n]"
        response = gets.chomp.downcase



        if response == "s"
          next

        elsif response == "n"
          puts "\nSaindo..."
        
        else
          puts "\nerro: Opção inválida!"

        end



        break

      end

    end

  end










  def createLoan
    data = readFile



    puts "\nDigite o título ou o ID do livro que será emprestado: "
    bookLoan = gets.chomp.strip.upcase

    puts "\nDigite o nome ou o ID do usuário que receberá o livro: "
    user = gets.chomp.strip.upcase



    if user.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !user.empty?
      user = data["users"].select { |e| e["name"].start_with?(user) ||  e["id"] == user.to_i }

    else
      throw :error, "\nerro: Tipo de entrada não permitida!"

    end



    value_user = outputBookUser "user", user, "emprestar o livro"



    response = gets.chomp.strip.downcase

    if response == "s"
      if bookLoan.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !bookLoan.empty?
        book = data["books"].select { |e| e["name"].start_with?(bookLoan) || e["id"] == bookLoan.to_i }

      else
        throw :error, "\nerro: Tipo de entrada não permitida!"

      end



      value_book = outputBookUser "book", book, "emprestar"



      response = gets.chomp.strip.downcase

      if response == "s"
        if !value_book["book_available"]
          throw :error, "\nerro: Livro indiponível!"
      
        end



        loan = {"book_id" => value_book["id"], "user_id" => value_user["id"]}

        data["loans"] << loan

        value_book["book_available"] = false



        writeFile(data)


        
        puts "\nEmpréstimo feito com sucesso!"

      elsif response == "n"
        puts "\nOperação encerrada!"

      else
        throw :error, "\nerro: Opção inválida!"
      
      end
    
    elsif response == "n"
      puts "\nOperação encerrada!"

    else
      throw :error, "\nerro: Opção não identificada!"

    end

  end










  def undoLoan
    data = readFile



    puts "\nDigite o título ou o ID do livro que será devolvido: "
    bookLoan = gets.chomp.strip.upcase


    
    if bookLoan.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !bookLoan.empty?
      book = data["books"].select { |e| e["id"] == bookLoan.to_i || e["name"].start_with?(bookLoan)}

    else
      throw :error, "\nerro: Tipo de entrada não permitida!"

    end



    value = outputBookUser "book", book, "devolver"



    response = gets.chomp.strip.downcase

    if response == "s"
      if !data["loans"].any? { |e| e["book_id"] == value["id"] }
        throw :error, "\nerro: Livro não emprestado!"
    
      end



      data["loans"] = data["loans"].reject! {|e| e["book_id"] == value["id"]}

      value["book_available"] = true



      writeFile(data)



      puts "\nDevolução feita com sucesso!"

    elsif response == "n"
      puts "\nOperação encerrada!"

    else
      throw :error, "\nerro: Opção inválida!"
    
    end

  end










  def findBookOrUser obj
    data = readFile



    if obj == "book"
      puts "\nDigite o nome ou o ID do livro: "
      value = gets.chomp.strip.upcase
      
      if value.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !value.empty?
        value = data["books"].select { |e| e["id"] == value.to_i || e["name"].start_with?(value) }

      else
        throw :error, "\nerro: Tipo de entrada não identificada!"
        
      end

    elsif obj == "user"
      puts "\nDigite o nome ou o ID do usuário: "
      value = gets.chomp.strip.upcase
      
      if value.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !value.empty?
        value = data["users"].select { |e| e["id"] == value.to_i || e["name"].start_with?(value) }
      
      else
        throw :error, "\nerro: Tipo de entrada não identificada!"

      end

    else
      throw :error, "\nerro: Tipo de entrada não identificada!"

    end


    
    if value[0].nil?
      throw :error, "\nerro: Livro(s) ou usuário(s) não encontrado(s)!"

    end
    


    msg = ""



    if obj == "user"
      value.each { |e| 
     
      msg += templateUser e

      }

    elsif obj == "book"
      value.each { |e|

      availableBook = e["book_available"] ? "Disponível" : "Indisponível"  

      msg += templateBook e, availableBook

      }
    
    else
      throw :error, "\nerro: Tipo de entrada não identificada!"

    end



    puts msg

  end










  def delete obj
    data = readFile



    if obj == "book"
      puts "\nDigite o nome ou o ID do livro: "
      value = gets.chomp.strip.upcase
      
      if value.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !value.nil?
        value = data["books"].select { |e| e["id"] == value.to_i || e["name"].start_with?(value) }

      else
        throw :error, "\nerro: Nome ou ID de usuário inválido!"
      
      end

    elsif obj == "user"
      puts "\nDigite o nome ou o ID do usuário: "
      value = gets.chomp.strip.upcase
      
      if value.match?(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !value.nil?
        value = data["users"].select { |e| e["id"] == value.to_i || e["name"].start_with?(value) }
      
      else
        throw :error, "\nerro: Nome ou ID de livro inválido"

      end

    else
      throw :error, "\nerro: Tipo de entrada não identificada!"
    
    end



    value = outputBookUser obj, value, "deletar"



    response = gets.chomp.downcase

    if response == "s"

      if obj == "user" 
        data["users"].reject! { |e| e == value }

      elsif obj == "book"
        data["books"].reject! { |e| e == value }
      
      else
        throw :error, "\nerro: Tipo de entrada não permitida!"

      end



      writeFile(data)



      puts "\nLivro ou usuário deletado com sucesso!"
    
    elsif response == "n"
      puts "\nOperação encerrada!"
    
    else
      throw :error, "\nerro: Opção inválida!"

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

  








  def invalidBook obj, search, title, author, publicationYear
    if !search.match(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/)
      throw :error, "\nerro: ID ou nome do livro inválido!"
          
    end



    if obj == "update"
      if !title.match(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/) && !title.empty?
        throw :error, "\nerro: Título do livro inválido!"
      
      end



      if !author.match(/\A[[:alpha:]ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç ]+\z/) && !author.empty?
        throw :error, "\nerro: Nome do autor inválido!"

      end



      if (!publicationYear.match?(/^-?\d+$/) || publicationYear.to_i > Time.now.year) && !publicationYear.empty?
        throw :error, "\nerro: Data de publicação do livro inválida!"

      end
      
    elsif obj == "create"
      if !title.match(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/)
        throw :error, "\nerro: Título do livro inválido!"
      
      end



      if !author.match(/\A[[:alpha:]ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç ]+\z/)
        throw :error, "\nerro: Nome do autor inválido!"

      end



      if !publicationYear.match?(/^-?\d+$/) || publicationYear.to_i > Time.now.year
        throw :error, "\nerro: Data de publicação do livro inválida!"

      end

    end

  end










  def invalidUser obj, name, email, search = ""
    if obj == "create"
      if !email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
        throw :error, "\nerro: E-mail inválido!"

      end



      if !name.match(/\A[[:alpha:]ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç ]+\z/)
        throw :error, "\nerro: Nome de usuário inválido!"  

      end
    
    elsif obj == "update"
      if !search.match(/\A[\w\s\-\–\—\.,:;!?()\'"“”‘’ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç]+\z/)
        throw :error, "\nerro: ID ou nome do livro inválido!"    
      
      end



      if !email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) && !email.empty?
        throw :error, "\nerro: E-mail inválido!"

      end



      if !name.match(/\A[[:alpha:]ÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç ]+\z/) && !name.empty?
        throw :error, "\nerro: Nome de usuário inválido!"  

      end

    else
      throw :error, "\nerro: Objeto não identificado!"
      
    end
  
  end










  def outputBookUser obj, value, verb
    if obj == "book"
      if value.length > 1
        msg = ""

        value.each { |e|

        availableBook = e["book_available"] ? "Disponível" : "Indisponível"  



        msg += templateBook e, availableBook

        }

        msg += "Foram encontrados mais de um livro que correspondem à sua busca. Digite o ID daquele que você deseja #{verb}: "



        puts msg
        response = gets.chomp.strip.to_i



        value = value.find { |e| e["id"] == response.to_i }

        if value.nil?
          throw :error, "\nerro: ID não corresponde a nenhum dos livros exibidos!"  

        end



        availableBook = value["book_available"] ? "Disponível" : "Indisponível" 



        msg = templateBook value, availableBook
        msg += "\nTem certeza que deseja #{verb} o livro exibido? [s/n]"



        puts msg
        


        return value

      elsif value.length == 1
        value = value[0]

        availableBook = value["book_available"] ? "Disponível" : "Indisponível"  



        msg = templateBook value, availableBook
        msg += "\nTem certeza que deseja #{verb} o livro exibido? [s/n]"



        puts msg
        


        return value

      else
        throw :error, "\nerro: Livro não encontrado!"

      end

    elsif obj == "user"
      if value.length > 1
        msg = ""

        value.each {|e|

        msg += templateUser e
        
        }

        msg += "\nForam encontrados mais de um usuário que correspondem à sua busca. Digite o ID daquele que você deseja #{verb}: "



        puts msg 
        response = gets.chomp.strip.to_i



        value = value.find { |e| e["id"] == response }

        if value.nil?
          throw :error, "\nerro: ID não corresponde a nenhum dos usuários exibidos!"  

        end



        msg = templateUser value
        msg += "\nTem certeza que deseja #{verb} o usuário exibido? [s/n]"



        puts msg



        return value

      elsif value.length == 1
        value = value[0]

        msg = templateUser value
        msg += "\nTem certeza que deseja #{verb} o usuário exibido? [s/n]"



        puts msg



        return value

      else
        throw :error, "\nerro: Usuário não encontrado!"

      end

    else
      throw :error, "\nerro: Objeto não identificado!"

    end

  end










  def conferUserBook obj, data, params
    if obj == "book"
      data["books"].each { |e|

        if e["name"] == params["name"] && e["book_author"] == params["book_author"] && e["book_publicationYear"] == params["book_publicationYear"] 
          throw :error, "\nerro: Esse livro já foi cadastrado!"

        end

      }

    elsif obj == "user"
      data["users"].each { |e|

        if e["user_email"] == params["user_email"]
          throw :error,  "\nerro: E-mail já foi cadastrado!"

        end 

      }
    
    else
      throw :error, "\nerro: Tipo de entrada não permitida!"

    end 

  end










  def AllEmptyFields params 

    if params.all? { |key, value| value == "" }
      throw :error, "\nerro: Nenhum campo foi preenchido!"
      
    end
  
  end









  
  def templateBook value, availableBook
    return <<~MSG
        =====================================================================
        ID: #{value["id"]}
        Título: #{value["name"]}
        Autor: #{value["book_author"]}
        Ano de publicação: #{value["book_publicationYear"]}
        Disponibilidade: #{availableBook}
        =====================================================================
    MSG
    
  end










  def templateUser value
    return <<~MSG
        =====================================================================
        ID: #{value["id"]}
        Nome: #{value["name"]}
        E-mail: #{value["user_email"]}
        =====================================================================
      MSG

  end
  
end
