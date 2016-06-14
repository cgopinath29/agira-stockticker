class RefreshTime < ActiveRecord::Base
  validates :seconds, presence: true
end
