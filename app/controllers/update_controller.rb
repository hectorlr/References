class UpdateController < ApplicationController

  def index

  end

  def addPerson
    person = params[:post][:addName]
    matrix.addPerson(person, 'add person '+ person)
    render 'update/index'
  end

  def deletePerson
    person = params[:post][:deleteName]
    matrix.deletePerson(person, 'delete person '+ person)
    render 'update/index'
  end

  def addReference
    referer = params[:post][:addRefererName]
    refered = params[:post][:addReferedName]
    reference = params[:addReference]
    matrix.addReference([referer, refered], reference, 'add reference ' + referer + ' ' + refered + ' ' + reference)
    render 'update/index'
  end

  def deleteReference
    referer = params[:post][:deleteRefererName]
    refered = params[:post][:deleteReferedName]
    matrix.deleteReference([referer, refered], 'delete reference ' + referer + ' ' + refered)
    render 'update/index'
  end

  def changeReference
    referer = params[:post][:changeRefererName]
    refered = params[:post][:changeReferedName]
    reference = params[:changeReference]
    matrix.changeReference([referer, refered], reference, 'change reference ' + referer + ' ' + refered + ' ' + reference)
    render 'update/index'
  end

end