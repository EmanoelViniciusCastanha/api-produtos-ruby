class CreateProdutos < ActiveRecord::Migration[8.1]
  def change
    create_table :produtos do |t|
      t.string  :nome,           null: false
      t.string  :categoria,      null: false, default: "Geral"
      t.integer :quantidade,     null: false, default: 0
      t.decimal :preco,          null: false, default: 0.0, precision: 10, scale: 2
      t.integer :estoque_minimo, null: false, default: 5
      t.timestamps
    end
  end
end
