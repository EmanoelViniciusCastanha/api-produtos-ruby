# Endpoints da API de produtos: CRUD + relatório.
class ProdutosController < ApplicationController
  before_action :set_produto, only: [ :show, :update, :destroy ]

  # Lista tudo, com filtro opcional por ?categoria=
  def index
    produtos = Produto.all
    produtos = produtos.where(categoria: params[:categoria]) if params[:categoria].present?
    render json: produtos.map(&:resumo)
  end

  def show
    render json: @produto.resumo
  end

  def create
    produto = Produto.new(produto_params)

    if produto.save
      render json: produto.resumo, status: :created
    else
      render json: { erros: produto.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @produto.update(produto_params)
      render json: @produto.resumo
    else
      render json: { erros: @produto.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @produto.destroy
    head :no_content
  end

  def relatorio
    render json: RelatorioEstoque.gerar(Produto.all.to_a)
  end

  private

  def set_produto
    @produto = Produto.find_by(id: params[:id])
    render json: { erro: "Produto não encontrado" }, status: :not_found if @produto.nil?
  end

  def produto_params
    # Saldo não entra aqui de propósito: ele só muda via movimentações.
    params.require(:produto).permit(:nome, :categoria, :preco, :estoque_minimo)
  end
end
