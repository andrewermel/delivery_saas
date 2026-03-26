namespace :inventory do
  desc "Recalcula e sincroniza todo o estoque com base em compras e vendas"
  task recalculate: :environment do
    puts "🔄 Iniciando recálculo de estoque..."

    Item.find_each do |item|
      puts "\n📦 Sincronizando: #{item.name}"

      # Calcula quantidade total de compras
      total_purchases = item.purchases.sum(:quantity)
      puts "  ├─ Total de compras: #{total_purchases} un"

      # Calcula quantidade total de vendas
      total_sales = item.sales.sum(:quantity)
      puts "  ├─ Total de vendas: #{total_sales} un"

      # Atualiza o quantity_in_stock
      new_quantity = total_purchases - total_sales
      old_quantity = item.quantity_in_stock
      
      item.update(quantity_in_stock: new_quantity)
      puts "  ├─ Estoque atualizado: #{old_quantity} → #{new_quantity} un"

      # Recalcula preço médio
      new_price = item.average_weighted_price
      old_price = item.price
      
      item.update(price: new_price)
      puts "  └─ Preço atualizado: R$ #{old_price} → R$ #{new_price}"
    end

    puts "\n✅ Recálculo concluído!"
  end

  desc "Limpa e reconstrói a tabela de Inventory com base em compras e vendas"
  task rebuild_inventory: :environment do
    puts "🔄 Reconstruindo tabela de Inventory..."

    # Limpa inventários antigos
    Inventory.delete_all
    puts "  ├─ Tabela de Inventory limpa"

    # Reconstrói a partir de compras
    Purchase.find_each do |purchase|
      Inventory.create!(
        item: purchase.item,
        company: purchase.company,
        quantity_change: purchase.quantity.to_i,
        movement_type: 'purchase',
        purchase: purchase,
        notes: "Compra de #{purchase.quantity}un a R$#{purchase.price}"
      )
    end
    puts "  ├─ #{Purchase.count} registros de compra recriados"

    # Reconstrói a partir de vendas
    Sale.find_each do |sale|
      Inventory.create!(
        item: sale.item,
        company: sale.company,
        quantity_change: -sale.quantity.to_i,
        movement_type: 'sale',
        sale: sale,
        notes: "Venda de #{sale.quantity}un a R$#{sale.unit_price}"
      )
    end
    puts "  └─ #{Sale.count} registros de venda recriados"

    puts "\n✅ Reconstrução concluída!"
  end

  desc "Executa ambos os recálculos (estoque + inventory)"
  task sync_all: :environment do
    Rake::Task["inventory:rebuild_inventory"].invoke
    Rake::Task["inventory:recalculate"].invoke
  end
end
