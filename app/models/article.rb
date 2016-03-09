class Article < ActiveRecord::Base
  validates :title, presence: true, length: { in: 3..50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
end