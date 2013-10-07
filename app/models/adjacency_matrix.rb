class AdjacencyMatrix
  @@adjacencyMatrix = []
  @@vertices = []

  def adjacencyMatrix
    @@adjacencyMatrix
  end

  def buildGraph(lineArray)
    if lineArray.is_a?(Array)
      lineArray.each do |line|
        words = line.split

        commandString = words.take(2).join

        if commandString == 'addperson'
          addPerson(words.drop(2).join)
        elsif commandString == 'addreference'
          addReference(words.drop(2).take(2), words.drop(4).join)
        elsif commandString == 'changereference'
          changeReference(words.drop(2).take(2), words.drop(4).join)
        elsif commandString == 'deletereference'
          deleteReference(words.drop(2))
        elsif commandString == 'deleteperson'
          deletePerson(words.drop(2).join)
        end
      end
    end
  end

  #possible errors: The user already exist,
  def addPerson(person)
    index = @@vertices.index(person)
    if index.nil?
      @@vertices.push(person)
      @@adjacencyMatrix.push([])
      @@adjacencyMatrix.each do |sub|
        sub.push(nil)
        while sub.size < @@adjacencyMatrix[0].size do
          sub.push(nil)
        end
      end
    else
      #error log: person already exists
    end
  end

  def addReference(people, recommendation)
    indexRecommender = @@vertices.index(people[0])
    indexRecommendee = @@vertices.index(people[1])
    recNumber=nil
    if recommendation == 'highlyrecommended'
      recNumber=3
    elsif recommendation == 'recommended'
      recNumber=1
    elsif recommendation == 'donotrecommend'
      recNumber=-1
    end
    if !recNumber.nil?
      if @@adjacencyMatrix[indexRecommendee][indexRecommender].nil?
        @@adjacencyMatrix[indexRecommendee][indexRecommender]=recNumber
      else
        #error log: Reference already exists, opt to change reference
      end
    else
      #error log: invalid recommendation
    end
  end

  def changeReference(people, recommendation)
    indexRecommender = @@vertices.index(people[0])
    indexRecommendee = @@vertices.index(people[1])
    recNumber=nil
    if recommendation == 'highlyrecommended'
      recNumber=3
    elsif recommendation == 'recommended'
      recNumber=1
    elsif recommendation == 'donotrecommend'
      recNumber=-1
    end
    if !recNumber.nil?
      if @@adjacencyMatrix[indexRecommendee][indexRecommender].nil?
        #error log: Reference does not exist, opt to add reference
      else
        @@adjacencyMatrix[indexRecommendee][indexRecommender]=recNumber
      end
    else
      #error log: invalid recommendation
    end
  end

  def deleteReference(people)
    indexRecommender = @@vertices.index(people[0])
    indexRecommendee = @@vertices.index(people[1])

    @@adjacencyMatrix[indexRecommendee][indexRecommender]=nil
  end

  def deletePerson(person)
    index = @@vertices.index(person)
    if index.nil?
      #error log: person does not exist
    else
      @@vertices.delete(person)
      @@adjacencyMatrix.delete_at(index)
      @@adjacencyMatrix.each do |sub|
        sub.delete(index)
      end
    end
  end
end