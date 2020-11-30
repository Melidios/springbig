class DataItem < ApplicationRecord
  validates :first, :last, format: { with: /\A[a-zA-Z]+\z/, message: "Invalid Fotmat: only letters are allowed" }, allow_blank: true
  validates :phone, format: { with: /(^|[ ])[2-9]/, message: "Invalid phone number format, must not contain 0-1 as 1st and 4th digits" }, allow_nil: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email" }, allow_blank: true
  validates :file_name, presence: { message: "Identifier can't be blank" }
  validates_presence_of :first, if: :last?, message: 'First name has to be present'
end
