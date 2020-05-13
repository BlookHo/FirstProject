class MainController < ApplicationController
  def index
    @info = "Главная"
  end

  def help
    @info = t('.help')
  end

  def contacts
    @info = t('.contacts')
  end

  def about
    @info = "О проекте"
  end
end
