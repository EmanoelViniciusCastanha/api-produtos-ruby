class CreateMovimentacoes < ActiveRecord::Migration[8.1]
  def change
    create_table :movimentacoes do |t|
      t.references :produto, null: false, foreign_key: true
      t.string  :tipo,       null: false
      t.integer :quantidade, null: false
      t.string  :observacao

      t.timestamps
    end

    add_index :movimentacoes, [ :produto_id, :created_at ]
  end
end
