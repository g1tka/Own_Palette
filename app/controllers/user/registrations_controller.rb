# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  include WordFilter
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    ng_words = load_ng_words("#{Rails.root}/ng_words.txt")
    
    # ユーザー名を大文字から小文字に変換してNGワードのチェックを行う
    downcased_name = params[:user][:name].downcase
    filtered_name = filter_ng_words(downcased_name, ng_words)

    # フィルター後の名前が変わっているかチェック
    if filtered_name != downcased_name
      flash[:alert] = "別の名前を使用してください。"
      redirect_to new_user_registration_path
      return
    end
    # NGワードが含まれていない場合は、元のユーザー名（大文字の場合はそのまま）で通常処理を実行
    params[:user][:name] = user_name
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    posts_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

end
