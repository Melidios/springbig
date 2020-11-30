class DataItem < ApplicationRecord
  validates :first, :last, length: { minimum: 2 }, format: { with: /[a-zA-Z0-9]/, message: "Invalid Fotmat: only letters are allowed" }, allow_nil: true
  validates :phone, length: { is: 10, message: "Invalid format, must contain 10 digits", allow_nil: true }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email" }
  validates :file_name, presence: { message: "Identifiler can't be blank" }
  validates_presence_of :first, if: :last?, format: { message: 'First name has to be present' }
end
