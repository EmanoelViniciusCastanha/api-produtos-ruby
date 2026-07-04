class Produto < ApplicationRecord
  CATEGORIAS_VALIDAS = [ "Geral", "Eletrônicos", "Alimentos", "Limpeza", "Vestuário" ].freeze

  has_many :movimentacoes, dependent: :destroy

  validates :nome, presence: true
  validates :preco, numericality: { greater_than_or_equal_to: 0 }
  validates :estoque_minimo, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :saldo, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :categoria, inclusion: { in: CATEGORIAS_VALIDAS }

  def estoque_baixo?
    saldo <= estoque_minimo
  end

  def valor_em_estoque
    saldo * preco
  end

  def situacao
    if saldo.zero?
      "SEM ESTOQUE"
    elsif estoque_baixo?
      "ESTOQUE BAIXO"
    else
      "OK"
    end
  end

  def resumo
    {
      id: id,
      nome: nome,
      categoria: categoria,
      saldo: saldo,
      preco: preco.to_f,
      estoque_minimo: estoque_minimo,
      situacao: situacao,
      valor_em_estoque: valor_em_estoque.to_f
    }
  end
end
