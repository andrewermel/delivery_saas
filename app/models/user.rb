class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  validates :company_id, presence: true, on: :update

  after_create :create_personal_company

  enum :role, { user: 0, admin: 1 }, suffix: true

  private

  def create_personal_company
    cnpj = generate_valid_cnpj

    company = Company.create!(
      name: "#{email.split('@').first.capitalize}'s Business",
      cnpj_id: cnpj
    )
    update(company_id: company.id)
  end

  def generate_valid_cnpj
    loop do
      candidate = format("%014d", Random.rand(10**14))
      break candidate unless Company.exists?(cnpj_id: candidate)
    end
  end
end
