class Waiter < ActiveRecord::Base
  mount_uploader :photo, WaiterImageUploader
  enum status: [ :hired, :fired]

  has_many :worksets

  def fullname
    "#{firstname} #{lastname}"
  end

  def waiters_share
    0.05
  end

end
