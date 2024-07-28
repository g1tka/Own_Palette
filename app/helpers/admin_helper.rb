module AdminHelper
  # if current_admin == Admin.find(2) をmethod化
  def is_guest_admin?
    current_admin == Admin.find(2)
  end
end
