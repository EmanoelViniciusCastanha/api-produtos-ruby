require "rails_helper"

RSpec.describe RegistrarMovimentacao, type: :service do
  let(:produto) { Produto.create!(nome: "Item", categoria: "Geral", preco: 10.0, estoque_minimo: 5) }

  it "uma entrada aumenta o saldo" do
    RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 10)
    expect(produto.reload.saldo).to eq(10)
  end

  it "uma saída diminui o saldo" do
    RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 10)
    RegistrarMovimentacao.call(produto: produto, tipo: "saida", quantidade: 4)
    expect(produto.reload.saldo).to eq(6)
  end

  it "não deixa a saída derrubar o saldo abaixo de zero" do
    RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 3)

    mov = RegistrarMovimentacao.call(produto: produto, tipo: "saida", quantidade: 10)

    expect(mov).not_to be_persisted
    expect(mov.errors[:quantidade]).to be_present
    expect(produto.reload.saldo).to eq(3)
  end

  it "não registra movimentação com quantidade inválida" do
    mov = RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 0)

    expect(mov).not_to be_persisted
    expect(produto.reload.saldo).to eq(0)
  end

  it "guarda o histórico das movimentações do produto" do
    RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 10, observacao: "Compra")
    RegistrarMovimentacao.call(produto: produto, tipo: "saida", quantidade: 2, observacao: "Venda")

    expect(produto.movimentacoes.count).to eq(2)
  end
end
