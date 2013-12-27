#Hector Rodriguez
#AdjacencyMatrix class

class AdjacencyMatrix
  @@adjacencyMatrix = []
  @@vertices = []
  @@file = File.open(Rails.root.join('public', 'uploads', 'GraphDoc.txt'))
  File.open(@@file.path, 'w') { |file| file.truncate(0) }
  @@errorFile = File.open(Rails.root.join('public', 'uploads', 'Errors.txt'))
  File.open(@@errorFile.path, 'w') { |file| file.truncate(0) }
  @@informationFile = File.open(Rails.root.join('public', 'uploads', 'Information.txt'))
  File.open(@@informationFile.path, 'w') { |file| file.truncate(0) }

  def adjacencyMatrix
    @@adjacencyMatrix
  end

  def buildGraph(lineArray)
    if lineArray.is_a?(Array)
      lineArray.each do |line|
        words = line.split

        commandString = words.take(2).join

        if commandString == 'addperson'
          addPerson(words.drop(2).join, line)
        elsif commandString == 'addreference'
          addReference(words.drop(2).take(2), words.drop(4).join, line)
        elsif commandString == 'changereference'
          changeReference(words.drop(2).take(2), words.drop(4).join, line)
        elsif commandString == 'deletereference'
          deleteReference(words.drop(2), line)
        elsif commandString == 'deleteperson'
          deletePerson(words.drop(2).join, line)
        end
      end
    end
  end

  #Add a person to the graph
  def addPerson(person, line)
    index = @@vertices.index(person)
    if index.nil?
      @@vertices.push(person.downcase)
      @@adjacencyMatrix.push([])
      @@adjacencyMatrix.each do |sub|
        sub.push(nil)
        while sub.size < @@adjacencyMatrix[0].size do
          sub.push(nil)
        end
      end
      writeToFile(line)
    else
      writeToErrorFile('person already exists - ' + line)
    end
  end

  #Add a reference between two people
  def addReference(people, recommendation, line)
    indexRecommender = @@vertices.index(people[0].downcase)
    indexRecommendee = @@vertices.index(people[1].downcase)
    recNumber=nil
    if recommendation.delete(' ') == 'highlyrecommended'
      recNumber=3
    elsif recommendation.delete(' ') == 'recommended'
      recNumber=1
    elsif recommendation.delete(' ') == 'donotrecommend'
      recNumber=-3
    end
    if !recNumber.nil? and !indexRecommendee.nil? and !indexRecommender.nil? and indexRecommendee != indexRecommender
      if @@adjacencyMatrix[indexRecommendee][indexRecommender].nil?
        @@adjacencyMatrix[indexRecommendee][indexRecommender]=recNumber
        writeToFile(line)
      else
        writeToErrorFile('reference already exists, opt to change reference - ' + line)
      end
    else
      writeToErrorFile('invalid add reference - ' + line)
    end
  end

  #Change a reference between two people
  def changeReference(people, recommendation, line)
    indexRecommender = @@vertices.index(people[0].downcase)
    indexRecommendee = @@vertices.index(people[1].downcase)
    recNumber=nil
    if recommendation.delete(' ') == 'highlyrecommended'
      recNumber=3
    elsif recommendation.delete(' ') == 'recommended'
      recNumber=1
    elsif recommendation.delete(' ') == 'donotrecommend'
      recNumber=-3
    end

    if !recNumber.nil? and !indexRecommendee.nil? and !indexRecommender.nil? and indexRecommendee != indexRecommender
      if @@adjacencyMatrix[indexRecommendee][indexRecommender].nil?
        writeToErrorFile('reference does not exist. Try to add reference')
      else
        @@adjacencyMatrix[indexRecommendee][indexRecommender]=recNumber
        writeToFile(line)
      end
    else
      writeToErrorFile('invalid change reference - ' + line)
    end
  end

  #Delete a reference between two people
  def deleteReference(people, line)
    indexRecommender = @@vertices.index(people[0].downcase)
    indexRecommendee = @@vertices.index(people[1].downcase)
    if !indexRecommendee.nil? and !indexRecommender.nil? and indexRecommendee != indexRecommender
      @@adjacencyMatrix[indexRecommendee][indexRecommender]=nil
      writeToFile(line)
    else
      writeToErrorFile('invalid delete reference - ' + line)
    end
  end

  #Delete a person from the graph
  def deletePerson(person, line)
    index = @@vertices.index(person.downcase)
    if index.nil?
      writeToErrorFile('person does not exist - ' + line)
    else
      @@vertices.delete(person.downcase)
      @@adjacencyMatrix.delete_at(index)
      @@adjacencyMatrix.each do |sub|
        sub.delete_at(index)
      end
      writeToFile(line)
    end
  end

  #Used to write a valid line to a file
  def writeToFile(line)
    File.open(@@file.path, 'a') do |file|
      file.puts(line)
      line = nil
      file.close
    end
  end

  #Used to write an error message to a file
  def writeToErrorFile(line)
    File.open(@@errorFile.path, 'a') do |file|
      file.puts(line)
      line = nil
      file.close
    end
  end

  #Used to write a user friendly output to a file
  def writeToInformationFile(line)
    File.open(@@informationFile.path, 'a') do |file|
      file.puts(line)
      line = nil
      file.close
    end
  end

  #Used to generate the html code for the table of recommendations about a person
  def getAboutOutput
    t = ""
    @@vertices.each do |name|
      personalReference = @@adjacencyMatrix.at(@@vertices.index(name.downcase))
      recHighly = ''
      recRec = ''
      recNo = ''
      personalReference.each_with_index do |value, index|
        if !value.nil?
          if value == 3
            recHighly += '<b>' + @@vertices.at(index).capitalize + '</b> '
          elsif value == 1
            recRec += '<b>' + @@vertices.at(index).capitalize + '</b> '
          elsif value == -3
            recNo += '<b>' + @@vertices.at(index).capitalize + '</b> '
          end

        end
      end
      t = t + '<tr><td><b>' + name.capitalize + '</b></td><td>' + recHighly + '</td><td>' + recRec + '</td><td>' + recNo + '</td></tr>'
    end
    t
  end
  #Used to generate the html code for the table of recommendations by a person
  def getWrittenOutput
    t = ''
    @@vertices.each_with_index do |name, index|
      recHighly = ''
      recRec = ''
      recNo = ''
      @@adjacencyMatrix.each_with_index do |sub, index2|
        sub.each_with_index do |value, index3|
          if !value.nil? and index3 == index
            if value == 3
              recHighly += '<b>' + @@vertices.at(index2).capitalize + '</b> '
            elsif value == 1
              recRec += '<b>' + @@vertices.at(index2).capitalize + '</b> '
            elsif value == -3
              recNo += '<b>' + @@vertices.at(index2).capitalize + '</b> '
            end
          end
        end
      end
      t = t + '<tr><td><b>' + name.capitalize + '</b></td><td>' + recHighly + '</td><td>' + recRec + '</td><td>' + recNo + '</td></tr>'
    end
    t
  end

  #Used to parse a matrix into a userfriendly output
  def createInformationFile
    @@vertices.each do |name|
      personalReference = @@adjacencyMatrix.at(@@vertices.index(name.downcase))
      referenceArray = []
      personalReference.each do |value|
        if !value.nil?
          if value == 3
            rec='Highly recommended by '
          elsif value == 1
            rec= 'Recommended by '
          elsif value == -3
            rec='Not Recommend by '
          end

          rec = rec + @@vertices.at(personalReference.index(value)).capitalize
          referenceArray.push(rec)
        end
      end
      writeToInformationFile(name.capitalize + ' - ' + referenceArray.to_s)
    end
  end

  #Get the statistics about a matrix
  def getStatistics
    stats = ''
    stats = 'Number of Persons = ' + @@vertices.size.to_s + '<br/>'
    numHigh = 0
    numRec = 0
    numNo = 0

    @@adjacencyMatrix.each do |sub|
      sub.each do |value|
        if value == 3
          numHigh += 1
        elsif value == 1
          numRec += 1
        elsif value == -3
          numNo += 1
        end
      end
    end
    stats += 'Number of Highly Recommended = ' + numHigh.to_s + '<br/>'
    stats += 'Number of Recommended = ' + numRec.to_s + '<br/>'
    stats += 'Number of Do Not Recommend = ' + numNo.to_s + '<br/>'
  end

  #Get the list of people who are given a Highly Recommended
  def getHighly
    highly = ''
    @@adjacencyMatrix.each_with_index do |sub, index|
      isHighly = false
      sub.each do |value|
        if value == 3
          isHighly = true
        end
      end
      if isHighly
        highly += @@vertices.at(index).capitalize + '<br/>'
      end
    end
    highly
  end

  #Get the top ranked person
  def getTop
    topTotal = 0
    topName = ''
    @@adjacencyMatrix.each_with_index do |sub, index|
      total = 0
      sub.each do |value|
        if !value.nil?
          total += value
        end
      end
      if total >= topTotal
        topTotal = total
        topName = @@vertices.at(index).capitalize
      end
    end
    topName + ' Score: ' + topTotal.to_s
  end
end