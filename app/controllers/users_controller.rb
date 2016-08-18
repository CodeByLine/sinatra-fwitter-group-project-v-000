class UsersController < ApplicationController

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end


  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to :'/tweets'
    end
  end

  post '/signup' do
    if params[:username] == '' || params[:email] =='' || params[:password]==''
      redirect to '/signup'
    else
      @user = User.new(:username=> params[:username], email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = user.id
      redirect to '/tweets'
    end

  end

  get '/login' do
    if session[:user_id]
      redirect to '/tweets'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:id])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else
      redirect to 'users/signup'
    end
  end


  get '/logout' do
    session.destroy
    redirect to :'/login'
  end

end
