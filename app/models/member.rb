class Member < ApplicationRecord
    has_many :books
    has_many :borrowings
    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone, presence: true, uniqueness: true
end
