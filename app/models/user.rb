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
    # Generate a unique CNPJ (just a number for now)
    cnpj = loop do
      candidate = format("%014d", SecureRandom.random_bytes(7).unpack1('N') % 10_000_000_000_000)
      break candidate unless Company.exists?(cnpj_id: candidate)
    end
    
    company = Company.create!(
      name: "#{email.split('@').first.capitalize}'s Business",
      cnpj_id: cnpj
    )
    update(company_id: company.id)
  end
end
