class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # if current_admin == Admin.find(2) をmethod化したis_guest_admin?はadmin_helper.rbに記述。
end
