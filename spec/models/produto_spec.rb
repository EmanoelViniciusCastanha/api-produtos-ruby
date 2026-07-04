require "rails_helper"

RSpec.describe Produto, type: :model do
  def novo_produto(attrs = {})
    Produto.new({ nome: "Item", categoria: "Geral", preco: 10.0, estoque_minimo: 5, saldo: 10 }.merge(attrs))
  end

  describe "validações" do
    it "é válido com os atributos padrão" do
      expect(novo_produto).to be_valid
    end

    it "exige nome" do
      expect(novo_produto(nome: "")).not_to be_valid
    end

    it "rejeita categoria fora da lista" do
      expect(novo_produto(categoria: "Inexistente")).not_to be_valid
    end

    it "rejeita saldo negativo" do
      expect(novo_produto(saldo: -1)).not_to be_valid
    end

    it "rejeita preço negativo" do
      expect(novo_produto(preco: -0.01)).not_to be_valid
    end
  end

  describe "#estoque_baixo?" do
    it "é true quando o saldo está no mínimo ou abaixo" do
      expect(novo_produto(saldo: 5, estoque_minimo: 5).estoque_baixo?).to be true
    end

    it "é false quando o saldo está acima do mínimo" do
      expect(novo_produto(saldo: 6, estoque_minimo: 5).estoque_baixo?).to be false
    end
  end

  describe "#situacao" do
    it "retorna SEM ESTOQUE quando o saldo é zero" do
      expect(novo_produto(saldo: 0).situacao).to eq("SEM ESTOQUE")
    end

    it "retorna ESTOQUE BAIXO quando está no limite" do
      expect(novo_produto(saldo: 3, estoque_minimo: 5).situacao).to eq("ESTOQUE BAIXO")
    end

    it "retorna OK quando há folga" do
      expect(novo_produto(saldo: 20, estoque_minimo: 5).situacao).to eq("OK")
    end
  end

  describe "#valor_em_estoque" do
    it "multiplica saldo pelo preço" do
      expect(novo_produto(saldo: 4, preco: 25.0).valor_em_estoque).to eq(100.0)
    end
  end
end
