require_relative 'Library.rb'



class User < Library

  def createUser(name, email)
    data = readFile

    newId = nextId(data["users"])

    name = name.strip.upcase

    email = email.strip



    if name.empty? || email.empty?
      puts "Nome ou e-mail do usuário não preenchido(s)! Tente novamente."
        


      return

    end

    if !email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      puts "E-mail inválido! Tente novamente."



      return

    end

    data["users"].each { |e|

      if e["name"] == name || e["user_email"] == email
        puts "Esse usuário ou e-mail já foi cadastrado!"



        return

      end }



    user = {
      id: newId,
      name: name,
      user_email: email
    }

    data["users"] << user
    


    writeFile(data)



    puts "Usuário adicionado com sucesso!"

  end





  def updateUser obj, name = "" , email = ""
    params = {"name" => name.strip.upcase, "user_email" => email.strip}

    data = readFile

    obj = obj.strip



    if name.empty? && email.empty?
      puts "Nenhum campo foi preenchido! Tente novamente."



      return

    end

    if !email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) && !email.empty?
      puts "E-mail inválido! Tente novamente."



      return

    end

    data["users"].each { |e|
    
    if e["user_email"] == email
      puts "Esse e-mail já foi cadastrado!"



      return
    
    end }



    if obj.match?(/^[1-9]\d*$/)
      value = data["users"].find { |e| e["id"] == obj.to_i }

    elsif !obj.match?(/^[1-9]\d*$/) && !obj.empty?
      value = data["users"].find { |e| e["name"].start_with?(obj.upcase) }
    
    else
      puts "Tipo de entrada não permitida! Tente novamente."



      return

    end



    if value.nil?
      puts "Usuário não encontrado! Tente novamente."



      return

    end



    msg = <<~MSG
    =====================================================================
    ID: #{value["id"]}
    Nome: #{value["name"]}
    E-mail: #{value["user_email"]}
    =====================================================================
    Tem certeza que deseja atualizar o usuário exibido? [s/n]
    MSG



    puts msg
    response = gets.chomp

    if response.downcase == "s"
      params.each { |key, valueHash|

      if (valueHash.is_a?(String) && !valueHash.empty?) || valueHash.is_a?(TrueClass) || valueHash.is_a?(FalseClass)
        value[key] = valueHash

      end }



      writeFile(data)



      puts "Usuário atualizado com sucesso!"
    
    else
      puts "Operação encerrada!"



      return
    
    end

  end
  
end