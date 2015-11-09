class UsersController < ApplicationController
  before_action :set_users, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 3)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Alpha Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      set_action_variables("created")
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your Account was successfully updated"
      redirect_to articles_path
    else
      set_action_variables("updated")
      render 'edit'
    end
  end

  def destroy  # not being used currently
    if @user.destroy
      flash[:danger] = "Account was successfully deleted"

      redirect_to articles_path
    else
      render 'show'
    end
  end

  private
    def set_action_variables(crud)
        @crud_action = crud
        @narrative = "account"
    end

    def set_users
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
      if current_user != @user
        flash[:danger] = "You can only edit your own account"
        redirect_to root_path
      end
    end
end