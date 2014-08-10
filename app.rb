require 'sinatra'
require 'sequel'

class Todo < Sinatra::Base
  set :environment, ENV['RACK_ENV']

  configure do
    DB = Sequel.connect("mysql://root:root@localhost/todo")

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
  end

  get '/' do
    return "foo"
  end
end

