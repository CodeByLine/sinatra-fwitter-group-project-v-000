class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @user = @current_user
      @user = User.find(session[:user_id])
      @tweets = @user.tweets.all
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :'tweets/new'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if @params[:content] != ''
      @user = User.find(session[:user_id])
      @tweet=Tweet.create(:content => params[:content], :user_id=>params[:user_id])
        # @user = current_user
      @user.tweets << @tweet
      erb:'tweets/show'
    else
      redirect to '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if !!session[:user_id]
      @user = User.find_by_id(session[:user_id])
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/show'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      if @tweet.user_id == session[:user_id] && !@tweet.content.empty?
        erb:'/tweets/edit'
      else
        redirect '/tweets/show' #redirect '/tweets'
      end
    else
      redirect '/login'
    end
  end


  post '/tweets/:id/edit' do
    redirect to("/tweets/#{params[:id]}/edit") if params[:content].empty?
     @tweet = Tweet.find_by_id(params[:id])
     @tweet.content = params[:content]
     @tweet.save
     redirect '/tweets'
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
      if session[:user_id]
        @user = User.find_by_id(params[:id])
        if session[:user_id] == @tweet.user_id
          @tweet.delete
          redirect to '/tweets'
        else
          redirect to '/login'
        end
      end
    end
end
