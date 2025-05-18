require_relative 'Library.rb'



class User < Library
  def createUser
    puts "\nDigite o nome do usuário: "
    name = gets.chomp.strip.upcase

    puts "\nDigite o e-mail do usuário: "
    email = gets.chomp.strip



    invalidUser "create", name, email


    
    params = {"name" => name, "user_email" => email}



    data = readFile



    conferUserBook "user", data, params


    
    newId = nextId(data["users"])


    
    user = {
      id: newId,
      name: name,
      user_email: email
    }

    data["users"] << user
    


    writeFile(data)



    puts "\nUsuário adicionado com sucesso!"

  end








  

  def updateUser
    puts "\nDigite o nome ou o ID do usuário: "
    search = gets.chomp.strip.upcase
              
    puts "\nDigite o nome do usuário ou apenas aperte ENTER se não desejar atualizar isso: "
    name = gets.chomp.strip.upcase
          
    puts "\nDigite o e-mail do usuário ou apenas aperte ENTER se não desejar atualizar isso: "
    email = gets.chomp.strip



    invalidUser "update", name, email, search
    
    

    params = {"name" => name, "user_email" => email}



    data = readFile

    

    conferUserBook "user", data, params



    value = data["users"].select { |e| e["id"] == search.to_i || e["name"].start_with?(search) }



    value = outputBookUser "user", value, "atualizar"


    
    response = gets.chomp.downcase

    if response == "s"
      params.each { |key, valueHash|

      if (valueHash.is_a?(String) && !valueHash.empty?) || valueHash.is_a?(TrueClass) || valueHash.is_a?(FalseClass)
        value[key] = valueHash

      end 
    
      }



      writeFile(data)



      puts "\nUsuário atualizado com sucesso!"
    
    elsif response == "n"
      puts "\nOperação encerrada!"
    
    else
      throw :error, "\nerro: Opção não válida!"

    end

  end
  
end