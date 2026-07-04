require "swagger_helper"

RSpec.describe "Movimentacoes", type: :request do
  let(:produto) { Produto.create!(nome: "Item", categoria: "Geral", preco: 10.0, estoque_minimo: 5) }

  path "/produtos/{produto_id}/movimentacoes" do
    parameter name: :produto_id, in: :path, schema: { type: :integer }, description: "ID do produto"

    get "Lista o histórico de movimentações do produto" do
      tags "Movimentações"
      produces "application/json"

      response "200", "histórico retornado" do
        schema type: :array, items: { "$ref" => "#/components/schemas/Movimentacao" }
        let(:produto_id) do
          RegistrarMovimentacao.call(produto: produto, tipo: "entrada", quantidade: 10)
          RegistrarMovimentacao.call(produto: produto, tipo: "saida", quantidade: 3)
          produto.id
        end

        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(2)
        end
      end
    end

    post "Registra uma entrada ou saída" do
      tags "Movimentações"
      consumes "application/json"
      produces "application/json"
      parameter name: :body, in: :body, schema: { "$ref" => "#/components/schemas/MovimentacaoInput" }

      response "201", "movimentação registrada (retorna o produto com o saldo atualizado)" do
        schema type: :object,
               properties: {
                 movimentacao: { "$ref" => "#/components/schemas/Movimentacao" },
                 produto: { "$ref" => "#/components/schemas/Produto" }
               }
        let(:produto_id) { produto.id }
        let(:body) { { movimentacao: { tipo: "entrada", quantidade: 10, observacao: "Compra" } } }

        run_test! do |response|
          expect(JSON.parse(response.body)["produto"]["saldo"]).to eq(10)
        end
      end

      response "422", "saída maior que o saldo (ou dados inválidos)" do
        schema "$ref" => "#/components/schemas/Erros"
        let(:produto_id) { produto.id }
        let(:body) { { movimentacao: { tipo: "saida", quantidade: 5 } } }

        run_test! do
          expect(produto.reload.saldo).to eq(0)
        end
      end

      response "404", "produto não encontrado" do
        schema type: :object, properties: { erro: { type: :string } }
        let(:produto_id) { 999999 }
        let(:body) { { movimentacao: { tipo: "entrada", quantidade: 1 } } }
        run_test!
      end
    end
  end
end
