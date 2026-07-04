class Movimentacao < ApplicationRecord
  belongs_to :produto

  enum :tipo, { entrada: "entrada", saida: "saida" }, validate: true

  validates :quantidade, numericality: { greater_than: 0, only_integer: true }

  # Quanto essa movimentação soma (ou subtrai) do saldo do produto.
  def efeito_no_saldo
    entrada? ? quantidade : -quantidade
  end

  def resumo
    {
      id: id,
      produto_id: produto_id,
      tipo: tipo,
      quantidade: quantidade,
      observacao: observacao,
      data: created_at
    }
  end
end
