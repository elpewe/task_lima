class SessionsController < ApplicationController
  def edit
    user = User.find_by_activation_token(params[:id])
    if user.try(:update,{activation_token: "", activation_status: "active"})
      flash[:success] = "Your account has been activated"
      redirect_to users_url
    else
      flash[:notice] = "Welcome to the Sample App!"
      redirect_to root_url
    end
  end



  def create
    username = params[:session][:username]
    password = params[:session][:password]
    user = User.where("username = ? and activation_status = ?", username, "active").first
    user_password = BCrypt::Engine.hash_secret(password, user.password_salt) unless user.blank?
    
    if !user_password.blank? and user.password_hash.eql? user_password
      session[:user] = user.id
      flash[:notice] = "Wellcome #{user.username}"
      log_in user
      redirect_to root_path
    else
      params[:username]
      flash.now[:danger] = "Username n Password not match"
      render "new"
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
