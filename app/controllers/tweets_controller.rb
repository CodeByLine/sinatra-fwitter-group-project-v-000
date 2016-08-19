class TweetsController < ApplicationController

  get '/tweets' do
    if session[:user_id]
      # @user = @current_user
      @user = User.find_by_id(session[:user_id])
      @tweets = @user.tweets.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content] == ""
      redirect "/tweets/new"
    else
      @user = User.find(session[:user_id])
      @tweet = Tweet.create(:content => params[:content], :user_id => params[ @user.id])
      @user.tweets << @tweet
      redirect "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id]
      if @user == @tweet.user
        erb :'/tweets/edit_tweet'
      else
        redirect "/tweets/#{@tweet.id}"
      end
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id/edit' do
      if params[:content] == ""
        redirect to "/tweets/#{params[:id]}/edit"
      else
        @tweet = Tweet.find_by_id(params[:id])
        @tweet.content = params[:content]
        @tweet.save
        redirect to "/tweets/#{@tweet.id}"
      end
    end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    @user = User.find_by_id(session[:user_id])
    if @user == @tweet.user
        @tweet.delete
        redirect to '/tweets'
    else
      redirect "/tweets/#{params[:id]}" #redirect to '/login'
    end
  end

end
