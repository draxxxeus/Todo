require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  configure do
    DB = Sequel.connect("mysql://root:root@localhost/todo")

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
  end
end

get '/?' do
  all_lists =  List.all
  haml :lists, locals: {lists: all_lists}
end

get '/new/?' do
  haml :new_list
end

post '/new/?' do
  # save the list
end

get '/edit/:id/?' do
  # check user permission and show the edit page
end

post '/edit/?' do
  # update the list
end

post '/permission/?' do
  # update permission
end

get '/signup/?' do
  # show signup form
end

post '/signup/?' do
  # save the user data
end

get '/login/?' do
  # show a login page
end

post '/login/?' do
  # validate user credentials
end
