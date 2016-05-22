class Admin::UsersController < Admin::AdminApplicationController
  before_filter :find_item, only:  [:show, :edit, :update, :destroy]

  before_action :signed_in_user, only: [:show, :edit, :update, :index, :destroy]

  def user

  end

  def new
    @user=User.new
  end

  def edit

  end

  def show

  end

  def create
    @user = User.new item_params
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to Cocktail Bar Admin Panel!'
      redirect_to admin_user_path(@user)
    else
      flash[:warning] = @user.errors.full_messages.to_sentence
      render :new
    end

  end

  def destroy
    @user.destroy
    redirect_to action: :new

  end

  def item_params
    params.require(:user).permit(:id, :email, :password, :password_confirmation, :name)
  end

  private
  def find_item
    @user = User.find(params[:id])
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to admin_signin_url, notice: 'Please sign_in'
    end
  end


end
