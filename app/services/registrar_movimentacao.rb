# Registra uma entrada/saída e atualiza o saldo do produto de forma atômica.
# Uma saída nunca pode deixar o saldo negativo.
class RegistrarMovimentacao
  def self.call(produto:, tipo:, quantidade:, observacao: nil)
    movimentacao = produto.movimentacoes.new(tipo: tipo, quantidade: quantidade, observacao: observacao)

    # with_lock abre uma transação e trava a linha do produto, evitando que
    # duas movimentações simultâneas leiam o mesmo saldo.
    produto.with_lock do
      if movimentacao.saida? && movimentacao.quantidade.to_i > produto.saldo
        movimentacao.errors.add(:quantidade, "maior que o saldo disponível (#{produto.saldo})")
      elsif movimentacao.save
        produto.update!(saldo: produto.saldo + movimentacao.efeito_no_saldo)
      end
    end

    movimentacao
  end
end
