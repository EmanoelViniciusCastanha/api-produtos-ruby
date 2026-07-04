require "rails_helper"

RSpec.describe Movimentacao, type: :model do
  let(:produto) { Produto.create!(nome: "Item", categoria: "Geral", preco: 10.0, estoque_minimo: 5) }

  it "pertence a um produto" do
    mov = Movimentacao.new(tipo: "entrada", quantidade: 5)
    expect(mov).not_to be_valid
    expect(mov.errors[:produto]).to be_present
  end

  it "rejeita quantidade zero ou negativa" do
    expect(produto.movimentacoes.new(tipo: "entrada", quantidade: 0)).not_to be_valid
    expect(produto.movimentacoes.new(tipo: "entrada", quantidade: -3)).not_to be_valid
  end

  it "rejeita tipo fora de entrada/saida" do
    expect(produto.movimentacoes.new(tipo: "transferencia", quantidade: 5)).not_to be_valid
  end

  describe "#efeito_no_saldo" do
    it "soma na entrada e subtrai na saída" do
      expect(produto.movimentacoes.new(tipo: "entrada", quantidade: 5).efeito_no_saldo).to eq(5)
      expect(produto.movimentacoes.new(tipo: "saida", quantidade: 5).efeito_no_saldo).to eq(-5)
    end
  end
end
