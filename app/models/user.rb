class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  validates :company_id, presence: true, on: :update

  after_create :create_personal_company

  enum :role, { user: 0, admin: 1 }, suffix: true

  private

  def create_personal_company
    company = Company.create!(
      name: "#{email.split('@').first.capitalize}'s Business",
      cnpj_id: "#{SecureRandom.hex(4)}-#{SecureRandom.hex(4)}"
    )
    update(company_id: company.id)
  end
end
