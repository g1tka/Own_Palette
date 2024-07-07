# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  def after_sign_in_path_for(resource)
    posts_path
  end
  
  private
  
  def user_state
    # [userのログインフォームに入力したemailの値]を用いて一致するemailカラムを持つuserを１件特定する。
    user = User.find_by(email: params[:user][:email])
    # もしuser=nilがtrueなら（存在しなければ）retuen（user_stateメソッド終了！）。falseなら次の行へ進む。
    return if user.nil?
    # [userのログインフォームに入力したpasswordの値]と先ほど特定したuserのpasswordが一致しないのであれば、retuen。trueなら次の行へ進む。
    return unless user.valid_password?(params[:user][:password])
    # ここでようやくis_activeがtrueかfalseかを条件分岐する。falseのときに実行したいことを
    unless user.is_active
      flash[:danger] = '退会済のアカウントです。新規登録をお願いします。'
      redirect_to new_user_session_path
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
end
