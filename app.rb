require 'rubygems'
require 'sinatra'
require 'json'
require 'dm-sqlite-adapter'
require 'data_mapper'

settings.server = "mongrel"

# Set up database and Todo model
DataMapper.setup(:default, "sqlite3:db/todo.db")

class Todo
  include DataMapper::Resource

  property :id, Serial
  property :text, String
  property :done, Boolean
end

DataMapper.finalize

# tell tilt to use .html.erb instead of .erb
Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
  erb :index, :locals => {:title => 'Welcome'}
end

get '/todo' do
  erb :todo, :locals => {:title => 'Todo App!'}
end

get '/api/:thing' do
  Todo.all.to_json
end

post '/api/:thing' do
  todo = JSON.parse(request.body.read.to_s)
  Todo.create(:text => todo["text"], :done => todo["done"])
end

put '/api/:thing/:id' do
  update = JSON.parse(request.body.read.to_s)
  todo = Todo.get(params[:id])
  todo.update(:text => update["text"], :done => update["done"])
end

delete '/api/:thing/:id' do
  todo = Todo.get(params[:id])
  todo.destroy
end
