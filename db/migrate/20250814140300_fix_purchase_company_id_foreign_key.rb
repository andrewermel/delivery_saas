class FixPurchaseCompanyIdForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Remove índice antigo se existir
    remove_index :purchases, :company_id, if_exists: true

    # Mudar tipo de company_id para bigint (se necessário)
    change_column :purchases, :company_id, :bigint

    # Adicionar foreign key explícita
    add_foreign_key :purchases, :companies, column: :company_id, if_not_exists: true
  end
end
