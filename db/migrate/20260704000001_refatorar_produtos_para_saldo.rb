class RefatorarProdutosParaSaldo < ActiveRecord::Migration[8.1]
  def change
    # Saldo passa a ser derivado das movimentações; deixa de ser editado direto.
    add_column :produtos, :saldo, :integer, null: false, default: 0
    remove_column :produtos, :quantidade, :integer, null: false, default: 0
  end
end
