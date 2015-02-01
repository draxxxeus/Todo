require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  configure do
    DB = Sequel.connect("mysql://root:root@localhost/todo")

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
  end


end

