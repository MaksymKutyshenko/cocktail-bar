class Admin::SessionsController < Admin::AdminApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    puts user

    if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:succes] = 'Welcome to Cocktail Bar!'
      redirect_back_or admin_user_path(user)
    else
      #create an error message and re-render the sign_in form
      flash[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to action: :new
  end

  def item_params
    params.require(:session).permit(:email, :password)
  end

end
