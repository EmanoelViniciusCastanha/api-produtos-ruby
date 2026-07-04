# Entradas e saídas de estoque de um produto.
class MovimentacoesController < ApplicationController
  before_action :set_produto

  # Histórico de entradas e saídas do produto, da mais recente pra mais antiga.
  def index
    render json: @produto.movimentacoes.order(created_at: :desc).map(&:resumo)
  end

  # Registra uma entrada ou saída e devolve o produto com o saldo já atualizado.
  def create
    movimentacao = RegistrarMovimentacao.call(
      produto: @produto,
      tipo: params.dig(:movimentacao, :tipo),
      quantidade: params.dig(:movimentacao, :quantidade),
      observacao: params.dig(:movimentacao, :observacao)
    )

    if movimentacao.persisted?
      render json: { movimentacao: movimentacao.resumo, produto: @produto.reload.resumo }, status: :created
    else
      render json: { erros: movimentacao.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def set_produto
    @produto = Produto.find_by(id: params[:produto_id])
    render json: { erro: "Produto não encontrado" }, status: :not_found if @produto.nil?
  end
end
