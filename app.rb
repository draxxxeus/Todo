require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  configure do
    DB = Sequel.connect("mysql://root:root@localhost/todo")

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }

    enable :sessions
  end
end

before do
  if not ['login', 'signup'].include? request.path_info.split('/')[1]  and session[:user_id].nil?
    redirect '/login'
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
  user = User.first(id: session[:user_id])
  List.new_list params[:title], params[:items], user
  redirect request.referer
end

get '/edit/:id/?' do
  list = List.first(id: params[:id])
  can_edit = true

  if list.nil?
    can_edit = false
  elsif list.shared_with == 'public'
    user = User.first(id: session[:user_id])
    permission = Permission.first(list: list, user: user)
    if permission.nil? or permission.permission_level == 'read_only'
      can_edit = false
    end
  end

  if can_edit
    haml :edit_list, locals: {list: list} if can_edit
  else
    haml :error, locals: {error: 'Invalid permissions'}
  end
end

post '/edit/?' do
  user = User.first(id: session[:user_id])
  List.edit_list params[:id], params[:name], params[:items], user
  redirect request.referer
end

post '/permission/?' do
  user = User.first(id: session[:user_id])
  list = List.first(id: params[:id])
  can_change_permission = true

  if list.nil?
    can_change_permission = false
  elsif list.shared_with != 'public'
    permission = Permission.first(list: list, user: user)
    if permission.nil? or permission.permission_level == 'read_only'
      can_change_permission = false
    end
  end

  if can_change_permission
    list.permission = params[:new_permissions]
    list.save

    current_permissions = Permission.first(list: list)
    current_permissions.each do |perm|
      perm.destroy
    end

    if params[:new_permissions] == 'private' or parms[:new_permissions] == 'shared'
      user_perms.each do |perm|
        u = User.first(perm[:user])
        Permission.create(list: list, user: u, permission_level: perm[:level], created_at: Time.now, updated_at: Time.now)
      end
    end

    redirect request.referer
  else
    haml :error, locals: {error: 'Invalid permissions'}
  end
end

get '/signup/?' do
  if session[:user_id].nil?
    haml :signup
  else
    haml :error, locals: {error: 'Please log out first'}
  end
end

post '/signup/?' do
  md5sum = Digest::MD5.hexdigest params[:password]
  User.create(name: params[:name], password: md5sum)

  haml :login
end

get '/login/?' do
  if session[:user_id].nil?
    session[:user_id] = "1"
    haml :login
  else
    haml :error, locals: {error: 'Please log out first'}
  end
end

post '/login/?' do
  md5sum = Digest::Md5.hexdigest params[:password]
  user = User.first(name: params[:name], password: md5sum)
  if user.nil?
    haml :error, locals: {error: 'Invalid login credentials'}
  else
    session[:user_id] = user.id
    redirect '/'
  end
end

get '/logout/?' do
  session[:user_id] = nil
  redirect '/login'
end
