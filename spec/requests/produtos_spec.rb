require "swagger_helper"

RSpec.describe "Produtos", type: :request do
  def cria_produto(attrs = {})
    Produto.create!({ nome: "Item", categoria: "Geral", preco: 10.0, estoque_minimo: 5 }.merge(attrs))
  end

  path "/produtos" do
    get "Lista os produtos" do
      tags "Produtos"
      produces "application/json"
      parameter name: :categoria, in: :query, required: false,
                schema: { type: :string }, description: "Filtra por categoria"

      response "200", "lista retornada" do
        schema type: :array, items: { "$ref" => "#/components/schemas/Produto" }
        let(:categoria) { nil }
        before { cria_produto(nome: "A"); cria_produto(nome: "B") }

        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(2)
        end
      end
    end

    post "Cadastra um produto" do
      tags "Produtos"
      consumes "application/json"
      produces "application/json"
      parameter name: :body, in: :body, schema: { "$ref" => "#/components/schemas/ProdutoInput" }

      response "201", "produto criado (nasce com saldo 0)" do
        schema "$ref" => "#/components/schemas/Produto"
        let(:body) { { produto: { nome: "Cadeira", categoria: "Geral", preco: 5.0, estoque_minimo: 2 } } }

        run_test! do |response|
          expect(JSON.parse(response.body)["saldo"]).to eq(0)
        end
      end

      response "422", "dados inválidos" do
        schema "$ref" => "#/components/schemas/Erros"
        let(:body) { { produto: { nome: "", categoria: "Geral", preco: 5.0, estoque_minimo: 2 } } }
        run_test!
      end
    end
  end

  path "/produtos/relatorio" do
    get "Relatório consolidado do estoque" do
      tags "Produtos"
      produces "application/json"

      response "200", "relatório gerado" do
        schema type: :object,
               properties: {
                 total_de_produtos: { type: :integer },
                 unidades_totais: { type: :integer },
                 valor_total_estoque: { type: :number },
                 custo_reposicao: { type: :number },
                 itens_criticos: { type: :array, items: { "$ref" => "#/components/schemas/Produto" } },
                 categoria_mais_estoque: { type: :string },
                 niveis_de_estoque: { type: :array, items: { type: :string } }
               }
        before { cria_produto(saldo: 10) }
        run_test!
      end
    end
  end

  path "/produtos/{id}" do
    parameter name: :id, in: :path, schema: { type: :integer }, description: "ID do produto"

    get "Detalha um produto" do
      tags "Produtos"
      produces "application/json"

      response "200", "produto encontrado" do
        schema "$ref" => "#/components/schemas/Produto"
        let(:id) { cria_produto.id }
        run_test!
      end

      response "404", "produto não encontrado" do
        schema type: :object, properties: { erro: { type: :string } }
        let(:id) { 999999 }
        run_test!
      end
    end

    patch "Atualiza os dados do produto (não o saldo)" do
      tags "Produtos"
      consumes "application/json"
      produces "application/json"
      parameter name: :body, in: :body, schema: { "$ref" => "#/components/schemas/ProdutoInput" }

      response "200", "produto atualizado" do
        schema "$ref" => "#/components/schemas/Produto"
        let(:id) { cria_produto.id }
        let(:body) { { produto: { nome: "Novo nome", categoria: "Geral", preco: 20.0, estoque_minimo: 4 } } }
        run_test!
      end
    end

    delete "Remove um produto" do
      tags "Produtos"

      response "204", "produto removido" do
        let(:id) { cria_produto.id }
        run_test!
      end
    end
  end
end
